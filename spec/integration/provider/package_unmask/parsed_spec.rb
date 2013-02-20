require 'spec_helper'

describe Puppet::Type.type(:package_unmask).provider(:parsed) do

  let(:path) { PuppetIntegration::TmpdirManager.instance.tmpfile }
  let(:type_class) { Puppet::Type.type(:package_unmask) }

  around(:each) do |example|
    described_class.stubs(:header).returns ''

    catalog = Puppet::Resource::Catalog.new
    resources.each { |r| catalog.add_resource r }
    catalog.apply
    example.run
    catalog.clear
  end

  describe "a single instance" do

    describe "without a version" do
      let(:resources) do
        # Well this is fucking cryptic.
        [] << type_class.new(
          :name     => 'app-admin/dummy',
          :target   => path,
          :provider => :parsed
        )
      end

      it 'should match the fixture' do
        actual = File.read(path)

        actual.slice!("app-admin/dummy\n").should_not be_nil
        actual.should be_empty
      end
    end

    describe "with a version" do
      let(:resources) do
        # This too. Srsly. wat.
        [] << type_class.new(
          :name     => 'app-admin/versioned-atom',
          :target   => path,
          :version  => '>=3.1.2-r1',
          :provider => :parsed
        )
      end

      it 'should match the fixture' do
        actual = File.read(path)

        actual.slice!(">=app-admin/versioned-atom-3.1.2-r1\n").should_not be_nil
        actual.should be_empty
      end
    end
  end

  describe "with multiple instances" do

    describe "without a version" do
      let(:resources) do
        r = []
        r << type_class.new(
          :name     => 'app-admin/first',
          :target   => path,
          :provider => :parsed
        )
        r << type_class.new(
          :name     => 'app-admin/second',
          :target   => path,
          :provider => :parsed
        )

        r
      end

      it 'should match the fixture' do
        actual = File.read(path)

        actual.slice!("app-admin/first\n").should_not be_nil
        actual.slice!("app-admin/second\n").should_not be_nil
        actual.should be_empty
      end
    end
  end
end
