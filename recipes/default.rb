#
# Cookbook Name:: msodbcsql
# Recipe:: default
#
# Copyright 2014, Mariani Lucas
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

node.set['build-essential']['compile_time'] = true
include_recipe 'build-essential::default'
include_recipe 'yum-epel::default'

package 'unixODBC' do
  action :remove
  ignore_failure true
end

node[:msodbcsql][:package].each do |pkg|
  package pkg do
    action :install
  end
end

gem_package 'tiny_tds' do
  action :install
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node[:msodbcsql][:unixodbc][:filename]}.tar.gz" do
  owner 'root'
  group 'root'
  mode '0644'
  source node[:msodbcsql][:unixodbc][:url]
  action :create_if_missing
end

execute 'UnixODBC_extract' do
  cwd Chef::Config[:file_cache_path]
  command "tar vzxf #{node[:msodbcsql][:unixodbc][:filename]}.tar.gz"
  action :run
  not_if { ::Dir.exist?("#{Chef::Config[:file_cache_path]}/#{node[:msodbcsql][:unixodbc][:filename]}") }
end

execute 'UnixODBC_configure' do
  cwd "#{Chef::Config[:file_cache_path]}/#{node[:msodbcsql][:unixodbc][:filename]}"
  command './configure  --prefix=/usr --libdir=/usr/lib64 --sysconfdir=/etc --enable-gui=no --enable-drivers=no --enable-iconv --with-iconv-char-enc=UTF8 --with-iconv-ucode-enc=UTF16LE'
  action :run
  not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/#{node[:msodbcsql][:unixodbc][:filename]}/Makefile") }
end

execute 'UnixODBC_make' do
  cwd "#{Chef::Config[:file_cache_path]}/#{node[:msodbcsql][:unixodbc][:filename]}"
  command 'make; make install'
  action :run
  not_if "odbcinst --version | grep #{node[:msodbcsql][:unixodbc][:version]}"
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node[:msodbcsql][:filename]}.tar.gz" do
  owner 'root'
  group 'root'
  mode '0644'
  source node[:msodbcsql][:url]
  action :create_if_missing
end

execute 'msodbcsql_extract' do
  cwd Chef::Config[:file_cache_path]
  command "tar vzxf #{node[:msodbcsql][:filename]}.tar.gz"
  action :run
  not_if { ::Dir.exist?("#{Chef::Config[:file_cache_path]}/#{node[:msodbcsql][:filename]}") }
end

execute 'msodbcsql_install' do
  cwd "#{Chef::Config[:file_cache_path]}/#{node[:msodbcsql][:filename]}"
  command './install.sh install --accept-license --force'
  action :run
  not_if "sqlcmd | grep #{node[:msodbcsql][:version]}"
end
