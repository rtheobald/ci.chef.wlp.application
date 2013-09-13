#
# Cookbook Name:: application_java
# Provider:: tomcat
#
# Copyright 2012, ZephirWorks
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include Chef::Mixin::LanguageIncludeRecipe

action :before_compile do

  # create server 
  wlp_server "#{new_resource.server_name}" do
    action :create
  end

  # (TODO: don't undersatnd this bit) define service beforehand - otherwise notifications from ruby_block won't work
  service "wlp-#{new_resource.server_name}" do
    supports :start => true, :restart => true, :stop => true, :status => true
    action :nothing
  end

  # add the applications.xml file
  file "#{@utils.serversDirectory}/#{new_resource.server_name}/applications.xml" do
    action :create_if_missing
    owner new_resource.owner
    group new_resource.group
    mode '0755'
    backup false
    content "<server description='Applications'></server>"
  end

  # replace the server.xml with the updated one which has the applications.xml include 
  # the server config is in this cookbook attributes, TODO: how to have them in this recipe?
  include_recipe "wlp::serverconfig"

end

action :before_deploy do
  add_application
end

# Add the new application include into the applications.xml file
def add_application
    config = ApplicationWLP::Applications.load(node, new_resource.server_name)
    config.include("${shared.config.dir}/#{new_resource.application.name}.xml")
    if config.modified
      config.save()
    end
end


action :before_migrate do
end

action :before_symlink do
end

action :before_restart do
end

action :after_restart do
end

def load_current_resource
  @utils = Liberty::Utils.new(node)
end
