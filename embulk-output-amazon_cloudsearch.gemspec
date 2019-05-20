Gem::Specification.new do |spec|
  spec.name          = "embulk-output-amazon_cloudsearch"
  spec.version       = "0.1.0"
  spec.authors       = ["Kenichi Takahashi"]
  spec.summary       = "Amazon Cloudsearch output plugin for Embulk"
  spec.description   = "Dumps records to Amazon Cloudsearch."
  spec.email         = ["kenichi.taka@gmail.com"]
  spec.licenses      = ["MIT"]
  spec.homepage      = "https://github.com/kenchan/embulk-output-amazon_cloudsearch"

  spec.files         = `git ls-files`.split("\n") + Dir["classpath/*.jar"]
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'aws-sdk-cloudsearchdomain', ['~> 1.9']
  spec.add_development_dependency 'embulk', ['>= 0.8.39']
  spec.add_development_dependency 'bundler', ['>= 1.10.6']
  spec.add_development_dependency 'rake', ['>= 10.0']
end
