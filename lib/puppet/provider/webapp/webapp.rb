require 'puppet/util/webapp'

Puppet::Type.type(:webapp).provide(:webapp) do

  include Puppet::Util::Webapp

  commands :webapp_config => '/usr/sbin/webapp-config'

  mk_resource_methods

  def self.instances
    webapps = webapp_config('--list-installs').split("\n")
    webapps.collect do |path|
      webapp = Puppet::Util::Webapp::parse_path(path)
      opts = ['--show-installed'] << Puppet::Util::Webapp::build_opts(webapp)
      app = webapp_config(opts)
      new(
        webapp.
          merge(Puppet::Util::Webapp::parse_app(app)).
          merge({:ensure => :present})
      )
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    opts = ['--install']
    webapp = parse_name(resource[:name]).merge({:secure => resource[:secure]})
    opts << build_opts(webapp)
    opts << resource[:appname] << resource[:appversion]
    webapp_config(opts)
  end

  def destroy
    opts = ['--clean']
    webapp = parse_name(resource[:name]).merge({:secure => resource[:secure]})
    opts << build_opts(webapp)
    opts << resource[:appname] << resource[:appversion]
    webapp_config(opts)
  end
end
