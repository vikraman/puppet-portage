dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))
$LOAD_PATH.unshift(dir, dir + 'lib', dir + '../lib')

require 'mocha'
require 'puppet'

RSpec.configure do |config|
  config.mock_with :mocha

  # (portage-#38) specs fail when /etc/portage/package.use/* files cannot be
  # chmodded. This isn't the best location for these stubs, but right now
  # they're pretty tightly integrated into the portagefile provider. Since
  # the portagefile provider is pretty universal across these specs, this will
  # do for now.
  config.before do
    Dir.stubs(:mkdir)
    File.stubs(:chmod)
  end
end
