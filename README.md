[![Build Status](https://travis-ci.org/psyreactor/msodbcsql-cookbook.svg?branch=master)](https://travis-ci.org/psyreactor/msodbcsql-cookbook)

MSODBCSQL Cookbook
===============

This cookbook install msodbcsql.

####[Microsoft ODBC Driver](http://www.microsoft.com/en-us/download/details.aspx?id=36437)
"The Microsoft ODBC Driver 11 for SQL Server provides robust data access to Microsoft SQL Server. It allows native C and C++ applications to leverage the standard ODBC API and connect to Microsoft SQL Server 2008, 2008 R2, SQL Server 2012, SQL Server 2014 and Windows Azure SQL Database. Microsoft ODBC Driver 11 for SQL Server also comes with powerful tools - sqlcmd and bcp."

Requirements
------------
#### Cookbooks:

- yum-epel - https://github.com/opscode-cookbooks/yum-epel
- build-essential - https://github.com/opscode-cookbooks/build-essential

The following platforms and versions are tested and supported using Opscode's test-kitchen.

- CentOS 5.8, 6.3

The following platform families are supported in the code, and are assumed to work based on the successful testing on CentOS.


- Red Hat (rhel)
- Fedora
- Amazon Linux

#### msodbcsql:default
##### Basic Config
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>node[:msodbcsql][:unixodbc][:version]</tt></td>
    <td>String</td>
    <td>Version UnixODBC to install</td>
    <td><tt>2.3.0</tt></td>
  </tr>
  <tr>
    <td><tt>node[:msodbcsql][:version]</tt></td>
    <td>String</td>
    <td>Version msodbcsql to install</td>
    <td><tt>11.0.2270.0</tt></td>
  </tr>
    <tr>
    <td><tt>node[:msodbcsql][:odbc][:dns]</tt></td>
    <td>Array</td>
    <td>Create dns entry on odbc.ini file</td>
    <td><tt>{"name":{"server": "ip or dns", "database": "database_name" }}</tt></td>
  </tr>
</table>

##LWRP

msodbcsql_odbc: Create entry on odbc.ini to conect SQL Server database.

```ruby
msodbcsql_odbc 'MSSQLSERVER1' do
  server '192.168.168.1'
  database 'test1'
  action :append
end
```

####create

Creates a new odbc file entry. If any entry already exists, it will be overwritten by this one.

```ruby
msodbcsql_odbc 'MSSQLSERVER1' do
  server '192.168.168.1'
  database 'test1'
  action :create
end
```

This will create an entry like this:

```ini
[MSSQLSERVER1]
driver = ODBC Driver 11 for SQL Server
server = 192.168.168.1
database = test1
```

####create_if_missing

Create a new odbc.ini file entry, only if one does not already exist for the given server. If one exists, this does nothing.

```ruby
msodbcsql_odbc 'MSSQLSERVER1' do
  server '192.168.168.1'
  database 'test1'
  action :create_if_missing
end
```

####append

Append odbc.ini record. If the name already exist in the ini file, overwrite the entry.

```ruby
msodbcsql_odbc 'MSSQLSERVER1' do
  server '192.168.168.1'
  database 'test1'
  action :append
end
```

####update

Updates the odbc.ini file entry. Does nothing if the entry does not exist.

```ruby
msodbcsql_odbc 'MSSQLSERVER1' do
  server '192.168.168.1'
  database 'test1'
  action :update
end
```

####remove

Removes an entry from the ini file. Does nothing if the entry does not exist.

```ruby
msodbcsql_odbc 'MSSQLSERVER1' do
  server '192.168.168.1'
  database 'test1'
  action :delete
end
```

Usage
-----
#### msodbcsql::default
Just include `msodbcsql` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[msodbcsql]"
  ]
}
```

Example Create odbc.ini entry

```json
"default_attributes": {
  "msodbcsql": {
    "odbc": {
      "dns": {
        "name 1": {
          "server": "ip or dns",
          "database": "name of database"
        },
        "name 2": {
          "server": "ip or dns",
          "database": "name of database"
        }
      }
    }
  }
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

[More details](https://github.com/psyreactor/msodbcsql-cookbook/blob/master/CONTRIBUTING.md)

License and Authors
-------------------
Authors:
Lucas Mariani (Psyreactor)
- [marianiluca@gmail.com](mailto:marianiluca@gmail.com)
- [https://github.com/psyreactor](https://github.com/psyreactor)