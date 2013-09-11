#
# Cookbook Name:: application_wlp
# Provider:: wlp_webapp
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
end

action :before_deploy do

  create_hierarchy

  create_application_xml_file

  add_application

end

action :before_migrate do
end

action :before_symlink do
end

action :before_restart do
end

action :after_restart do
end

protected

def create_hierarchy
  %w{ log pids system }.each do |dir|
    directory "#{new_resource.path}/shared/#{dir}" do
      owner new_resource.owner
      group new_resource.group
      mode '0755'
      recursive true
    end
  end
end

def add_application
    config = ApplicationWLP::Applications.load(node, new_resource.server_name)
    config.include("/opt/was/liberty/wlp/usr/shared/config/#{new_resource.application.name}.xml")
    if config.modified
      config.save()
#      notifies_delayed(:restart, resources(:service => "wlp-#{new_resource.server_name}"))
    end
end

def create_application_xml_file

  template "/opt/was/liberty/wlp/usr/shared/config/#{new_resource.application.name}.xml" do
    source new_resource.application_xml_template || "application.xml.erb"
    cookbook new_resource.application_xml_template ? new_resource.cookbook_name.to_s : "application_wlp"
    owner new_resource.owner
    group new_resource.group
    mode "644"
    variables(
      :description => "#{new_resource.description || new_resource.application.name}",
      :features => new_resource.features,
      :app_location => new_resource.application_location,
      :app_name => "#{new_resource.application.name}",
      :app_id => new_resource.application_id,
      :app_type => new_resource.application_type,
      :app_context_root => new_resource.application_context_root,
      :app_autoStart => new_resource.application_autoStart
    )
  end

end
