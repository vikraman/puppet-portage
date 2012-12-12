#!/usr/bin/env rspec
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe Puppet::Util::Portage do
  describe ".valid_atom?" do

    valid_atoms   = %w{=sys-devel/gcc-4.3.2-r4 >=app-crypt/gnupg-1.9 net-analyzer/nagios-nrpe}
    invalid_atoms = %w{sys-devel-gcc =sys-devel/gcc}

    valid_atoms.each do |atom|
      it "should accept #{atom} as a valid name" do
        Puppet::Util::Portage.valid_atom?(atom).should be_true
      end
    end

    invalid_atoms.each do |atom|
      it "should reject #{atom} as an invalid name" do
        Puppet::Util::Portage.valid_atom?(atom).should be_false
      end
    end
  end

  describe ".valid_package?" do
    valid_packages = [
      'app-accessibility/brltty',
      'dev-libs/userspace-rcu',
      'sys-dev/gcc',
    ]

    invalid_packages = [
      'app-accessibility/brltty-',
      'gcc',
      'sys-dev-gcc',
      '=app-admin/eselect-fontconfig-1.1',
    ]

    valid_packages.each do |package|
      it "should accept #{package} as valid" do
        Puppet::Util::Portage.valid_package?(package).should be_true
      end
    end

    invalid_packages.each do |package|
      it "should reject #{package} as invalid" do
        Puppet::Util::Portage.valid_package?(package).should be_false
      end
    end
  end

  describe "valid_version?" do
    comparators = %w{~ < > = <= >=}

    valid_versions = [
      '4.3.2-r4',
      '1.3',
      '0.5.2_pre20120527',
      '3.0_alpha12',
    ]

    invalid_versions = [
      '!4.3.2-r4',
      '4.2.3>',
      'alpha',
      'alpha-2.4.1'
    ]

    valid_versions.each do |ver|
      it "should accept #{ver} as valid" do
        Puppet::Util::Portage.valid_version?(ver).should be_true
      end
    end

    describe 'with comparators' do
      comparators.each do |comp|
        valid_versions.each do |ver|
          ver_str = comp + ver
          it "should accept #{ver_str} as valid" do
            Puppet::Util::Portage.valid_version?(ver_str).should be_true
          end
        end
      end
    end

    invalid_versions.each do |ver|
      it "should reject #{ver} as invalid" do
        Puppet::Util::Portage.valid_version?(ver).should be_false
      end
    end
  end
end
