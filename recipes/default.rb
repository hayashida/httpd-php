#
# Cookbook Name:: httpd-php
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

service "iptables" do
	action [:stop, :disable]
end

%w{php php-common php-mbstring php-xml php-devel php-process php-cli php-mysql}.each do |p|
	package p do
		action :install
	end
end

package "httpd" do
	action :install
end

service "httpd" do
	supports :status => true, :restart => true, :reload => true
	action [:enable, :start]
end

group "apache" do
	action :modify
	members ["vagrant"]
	append true
	notifies :restart, "service[httpd]"
end

template "/etc/httpd/conf/httpd.conf" do
	source "httpd.conf.erb"
	mode "0644"
	notifies :restart, "service[httpd]"
end

template "/etc/httpd/conf.d/php.conf" do
	source "php.conf.erb"
	mode "0644"
	notifies :restart, "service[httpd]"
end

template "/etc/php.ini" do
	source "php.ini.erb"
	mode "0644"
	notifies :restart, "service[httpd]"
end
