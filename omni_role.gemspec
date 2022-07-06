require_relative "lib/omni_role/version"

Gem::Specification.new do |spec|
  spec.name        = "omni_role"
  spec.version     = OmniRole::VERSION
  spec.authors     = ["Andersen Fan"]
  spec.email       = ["as181920@gmail.com"]
  spec.homepage    = "https://github.com/as181920/omni_role"
  spec.summary     = "Common role and permission management"
  spec.description = ""
  spec.license     = "MIT"

  spec.metadata["allowed_push_host"] = "https://gems.io-note.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/as181920/omni_role"
  spec.metadata["changelog_uri"] = "https://github.com/as181920/omni_role"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 6.1"
end
