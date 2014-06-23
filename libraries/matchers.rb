if defined?(ChefSpec)

  def create_msodbcsql_odbc(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:msodbcsql_odbc, :create, resource)
  end

  def create_if_missing_msodbcsql_odbc(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:msodbcsql_odbc, :create_if_missing, resource)
  end

  def append_msodbcsql_odbc(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:msodbcsql_odbc, :append, resource)
  end

  def update_msodbcsql_odbc(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:msodbcsql_odbc, :update, resource)
  end

  def remove_msodbcsql_odbc(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:msodbcsql_odbc, :remove, resource)
  end

end
