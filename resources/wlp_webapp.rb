#
# Cookbook Name:: application_wlp
# Resource:: wlp_webapp
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

include ApplicationCookbook::ResourceBase

attribute :application_xml_template, :kind_of => [String, NilClass], :default => nil

attribute :description, :kind_of => [String, NilClass], :default => nil
attribute :features, :kind_of => Array, :default => []

attribute :application_location, :kind_of => String
attribute :application_id, :kind_of => [String, NilClass], :default => nil
attribute :application_type, :kind_of => [String, NilClass], :default => nil
attribute :application_context_root, :kind_of => [String, NilClass], :default => nil
attribute :application_autoStart, :kind_of => [String, NilClass], :default => nil

