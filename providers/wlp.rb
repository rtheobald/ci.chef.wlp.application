# Cookbook Name:: wlp
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

include Chef::Mixin::LanguageIncludeRecipe

action :before_compile do

  wlp_server "#{new_resource.server_name}" do
    config (new_resource.config)
    action :create_if_missing
  end

end

action :before_deploy do
  add_application

  # TODO: this isn't the correct place to do the start
  # because before deploy the app file wont be deployed to the correct location yet
  wlp_server (new_resource.server_name) do
    action :start
  end

end

# Add the new application include into the server.xml file
def add_application
    config = ApplicationWLP::Applications.load(node, new_resource.server_name)
    config.include("${server.config.dir}/#{new_resource.application.name}.xml")
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
