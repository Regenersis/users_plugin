Gem::Specification.new do |s|
  s.name          = "users_cas_auth"
  s.version       = "0.0.5"
  s.date          = "2012-10-04"
  s.authors       = ["vn2developers"]
  s.email         = "vn2developers@regenersis.com"
  s.homepage      = ''
  s.summary       = "Users CAS Authentication"
  s.description   = "Handle CAS authentication of users and their storage in session"
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency "active_record"
  s.add_development_dependency "active_resource"
  s.add_development_dependency "sentient_user"
end
