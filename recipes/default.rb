#
# Cookbook Name:: lwrp_dsl
# Recipe:: default
#
# Copyright 2014, Danyel Bayraktar
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

node["lwrp_dsl"]["run_list"].each do |resource, name_attribute, attributes = []|
  public_send(resource, name_attribute) do
    attributes.each do |name, *value|
      public_send(name, *value)
    end
  end
end