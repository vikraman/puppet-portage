#!/usr/bin/env rspec
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe Puppet::Util::Portage do
  describe "when validating atoms" do

    valid_atoms = [
      '=foo/bar-1.0.0',
      '>=foo/bar-1.0.0',
      '<=foo/bar-1.0.0',
      '>foo/bar-1.1.0',
      '<foo/bar-1.0.0',
      'foo1-bar2/messy_atom++',
    ]

    invalid_atoms = [
      'sys-devel-gcc',
      '=sys-devel/gcc',
      # version without quantifier
      'foo1-bar2/messy_atom++-1.0',
    ]

    valid_atoms.each do |atom|
      it "should accept '#{atom}' as a valid name" do
        Puppet::Util::Portage.valid_atom?(atom).should be_true
      end
    end

    invalid_atoms.each do |atom|
      it "should reject #{atom} as an invalid name" do
        Puppet::Util::Portage.valid_atom?(atom).should be_false
      end
    end
  end
end
