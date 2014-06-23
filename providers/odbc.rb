#
# Cookbook Name:: msodbcsql
# provider:: entry
#
# Copyright 2014, Mariani Lucas
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

use_inline_resources if defined?(use_inline_resources)

def whyrun_suppoted?
  true
end

action :create do
  if odbc_file_exist?
    Chef::Log.debug "#{node[:msodbcsql][:odbc][:file]} already exists - overwriting."
    ::File.delete(node[:msodbcsql][:odbc][:file])
  end
  odbc_file_create
  odbc_section_add
end

action :create_if_missing do
  if odbc_file_exist?
    Chef::Log.debug "#{node[:msodbcsql][:odbc][:file]} already exists - - skipping create_if_missing."
  else
    odbc_file_create
  end
  if odbc_section_exist?
    Chef::Log.debug "section #{new_resource.name} already exists - - skipping create_if_missing."
  else
    odbc_section_add
  end
end

action :append do
  if odbc_file_exist?
    odbc_section_add
  else
    Chef::Log.debug "#{node[:msodbcsql][:odbc][:file]} does not exist - creating instead."
    odbc_file_create
    odbc_section_add
  end
end

action :update do
  if odbc_file_exist?
    if odbc_section_exist?
      odbc_section_add
    else
      Chef::Log.debug "section #{new_resource.name} does not exist - skipping update."
    end
  else
    Chef::Log.debug "#{node[:msodbcsql][:odbc][:file]} does not exist - skipping update."
  end
end

action :remove do
  if odbc_file_exist?
    if odbc_section_exist?
      odbc_section_remove
    else
      Chef::Log.debug "section #{new_resource.name} does not exist - - skipping remove."
    end
  else
    Chef::Log.debug "#{node[:msodbcsql][:odbc][:file]} not exists - - skipping remove."
  end
end

private

def odbc_file_exist?
  ::File.exist?(node[:msodbcsql][:odbc][:file])
end

def odbc_section_exist?
  odbc_file = IniFile.load(node[:msodbcsql][:odbc][:file])
  odbc_file.has_section?(new_resource.name)
end

def odbc_file_create
  IniFile.new(:filename => node[:msodbcsql][:odbc][:file], :encoding => 'UTF-8').write
end

def odbc_section_add
  odbc_file = IniFile.load(node[:msodbcsql][:odbc][:file])
  odbc_file[new_resource.name] = {
    'Driver' => 'ODBC Driver 11 for SQL Server',
    'Server' => new_resource.server,
    'Database' => new_resource.database
  }
  odbc_file.write
end

def odbc_section_remove
  odbc_file = IniFile.load(node[:msodbcsql][:odbc][:file])
  odbc_file.delete_section(new_resource.name)
  odbc_file.write
end
