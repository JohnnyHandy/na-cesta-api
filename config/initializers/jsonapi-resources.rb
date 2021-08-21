JSONAPI.configure do |config|
  config.json_key_format = :underscored_key

  config.allow_include = true
  config.allow_sort = true
  config.allow_filter = true

  config.raise_if_parameters_not_allowed = true
end