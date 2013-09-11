name             "application_wlp"
maintainer       "IBM"
maintainer_email ""
license          "Apache 2.0"
description      "Deploys and configures applications to WebSphere Application Server Liberty Profile"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "2.0.0"

%w{ java wlp }.each do |cb|
  depends cb
end

depends "application", "~> 3.0"
