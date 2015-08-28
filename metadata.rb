name             "application_wlp"
maintainer       "IBM"
maintainer_email ""
license          "Apache 2.0"
description      "Deploys and configures applications to WebSphere Application Server Liberty Profile"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.3.0"

supports "debian"
supports "ubuntu"
supports "centos"
supports "redhat"

depends "application", ">= 4.1.2"
depends "wlp_ibm"
