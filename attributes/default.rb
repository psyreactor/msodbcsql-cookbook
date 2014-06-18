default[:msodbcsql][:unixodbc][:version] = '2.3.0'
default[:msodbcsql][:unixodbc][:filename] = "unixODBC-#{node[:msodbcsql][:unixodbc][:version]}"
default[:msodbcsql][:unixodbc][:url] = "ftp://ftp.unixodbc.org/pub/unixODBC/#{node[:msodbcsql][:unixodbc][:filename]}.tar.gz"

default[:msodbcsql][:version] = '11.0.2270.0'
default[:msodbcsql][:filename] = "msodbcsql-#{node[:msodbcsql][:version]}"

default[:msodbcsql][:url] = "http://download.microsoft.com/download/B/C/D/BCDD264C-7517-4B7D-8159-C99FC5535680/RedHat6/#{node[:msodbcsql][:filename]}.tar.gz"
default[:msodbcsql][:package] = %w(freetds freetds-devel)
