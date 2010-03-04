Gem::Specification.new do |s|
  s.name = 'flexible_csv'
  s.version = '0.2.2'
  s.author = 'Chris Powers'
  s.date = "2010-03-05"
  s.homepage = 'http://github.com/chrisjpowers/flexible_csv'
  s.email = 'chrisjpowers@gmail.com'
  s.summary = 'The FlexibleCsv gem uses the FasterCSV gem to parse user created CSV files that may not have standard headers.'
  s.files = ['README.rdoc', 'CHANGELOG.rdoc', 'LICENSE', 'lib/flexible_csv.rb', 'lib/hacks.rb', 'test/flexible_csv.rspec']
  s.require_paths = ["lib"]
  s.has_rdoc = true
  s.add_dependency('fastercsv', '>= 1.2.3')
end
