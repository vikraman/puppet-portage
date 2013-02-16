dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))
$LOAD_PATH.unshift(dir, dir + 'lib', dir + '../lib')

require 'mocha'
require 'puppet'

RSpec.configure do |config|
  config.mock_with :mocha
end

##
# This method loads system atoms under /usr/portage in an array.
#
# This is useful for fuzzy testing the atom validation and writing new test
# cases.
#
def system_atoms
  atoms = []

  Dir.glob('/usr/portage/*/*').each do |dir|
    next unless File.directory? dir
    atoms << dir.split('/').slice(3,4).join('/')
  end

  atoms
end
