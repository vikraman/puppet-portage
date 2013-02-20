require 'spec_helper'

describe Puppet::Type.type(:package_mask).provider(:parsed) do

  let(:path) { PuppetIntegration::TmpdirManager.instance.tmpfile }
  let(:type_class) { Puppet::Type.type(:package_mask) }

  around(:each) do |example|
    described_class.stubs(:header).returns ''

    catalog = Puppet::Resource::Catalog.new
    resources.each { |r| catalog.add_resource r }
    catalog.apply
    example.run
    catalog.clear
  end

  subject { File.read(path) }

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

      it { should have(1).lines }
      it { should match %r[^app-admin/dummy$] }
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

      it { should have(1).lines }
      it { should match %r[^>=app-admin/versioned-atom-3.1.2-r1$] }
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

      it { should have(2).lines }
      it { should match %r[^app-admin/first$] }
      it { should match %r[^app-admin/second$] }
    end
  end
end
