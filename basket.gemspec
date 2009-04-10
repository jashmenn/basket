# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{basket}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nate Murray"]
  s.autorequire = %q{basket}
  s.date = %q{2009-04-10}
  s.description = %q{Easily process and sort a directory of files.}
  s.email = %q{nate@natemurray.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "lib/basket.rb", "lib/ext", "lib/ext/core.rb", "lib/ext/metaid.rb", "lib/has_logger.rb", "spec/basket_spec.rb", "spec/spec_helper.rb", "examples/01_simple.rb", "examples/02_conditional.rb", "examples/03_other_baskets.rb", "examples/04_parallel.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://www.xcombinator.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Easily process and sort a directory of files.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<forkoff>, [">= 0.0.1"])
    else
      s.add_dependency(%q<forkoff>, [">= 0.0.1"])
    end
  else
    s.add_dependency(%q<forkoff>, [">= 0.0.1"])
  end
end
