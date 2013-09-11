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
  # TODO: bug in wlp_create causes fail is server already exists?
  wlp_server "#{@serverName}" do
    action :destroy
  end
  wlp_server "#{@serverName}" do
    action :create
  end

  # (TODO: don't undersatnd this bit) define service beforehand - otherwise notifications from ruby_block won't work
  service "wlp-#{@serverName}" do
#  service "wlp-Test1" do
    supports :start => true, :restart => true, :stop => true, :status => true
    action :nothing
  end


  # replace the server.xml with the updated one which has the applications.xml include 
  # the server config is in this cookbook attributes, TODO: how to have them in this recipe?
  include_recipe "wlp::serverconfig"

  # add the applications.xml file
  file "/opt/was/liberty/wlp/usr/servers/Test1/applications.xml" do
    action :create_if_missing
    owner new_resource.owner
    group new_resource.group
    mode '0755'
    backup false
    content "<server description='Applications'></server>"
  end


#  include_recipe "tomcat"
#
#  unless new_resource.restart_command
#    new_resource.restart_command do
#      run_context.resource_collection.find(:service => "tomcat").run_action(:restart)
#    end
#  end

end

action :before_deploy do

  new_resource = @new_resource

#  # remove ROOT application
#  # TODO create a LWRP to enable/disable tomcat apps
#  directory "#{node['tomcat']['webapp_dir']}/ROOT" do
#    recursive true
#    action :delete
#    not_if "test -L #{node['tomcat']['context_dir']}/ROOT.xml"
#  end
#
#  link "#{node['tomcat']['context_dir']}/#{new_resource.application.name}.xml" do
#    to "#{new_resource.application.path}/shared/#{new_resource.application.name}.xml"
#    notifies :restart, resources(:service => "tomcat")
#  end

end

action :before_migrate do
end

action :before_symlink do
end

action :before_restart do
end

action :after_restart do
end
