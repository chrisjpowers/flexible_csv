class FasterCSV::Row
  # allows for hash access by virtual attributes
  def method_missing(method_name, *args)
    self[method_name] || self[method_name.to_s] || super
  end
end