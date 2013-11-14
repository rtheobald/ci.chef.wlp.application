# Cookbook Name:: wlp_test
# Attributes:: default
#
# (C) Copyright IBM Corporation 2013.
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

include_recipe "wlp"

uri = ::URI.parse("http://central.maven.org/maven2/org/apache/geronimo/samples/jsp-examples-war/3.0-M1/jsp-examples-war-3.0-M1.war")
base_filename = ::File.basename(uri.path)
cache_file = "#{Chef::Config[:file_cache_path]}/#{base_filename}"

remote_file cache_file do
  source uri.to_s
  user node[:wlp][:user]
  group node[:wlp][:group]
end

server_name = "jsp-examples-local"

application "jsp-examples-local" do
  repository cache_file
  path "/usr/local/jsp-examples-local"
  scm_provider Chef::Provider::File::Deploy

  owner node[:wlp][:user]
  group node[:wlp][:group]

  wlp_application do
    server_name server_name
    features [ "jsp-2.2" ]
  end
end

# start server if it is not running already
wlp_server server_name do
  action :start
end
