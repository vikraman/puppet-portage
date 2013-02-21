require 'spec_helper'

describe Puppet::Type.type(:package_use).provider(:parsed) do

  let(:path) { PuppetIntegration::TmpdirManager.instance.tmpfile }
  let(:type_class) { Puppet::Type.type(:package_use) }

  around(:each) do |example|
    described_class.stubs(:header).returns ''

    catalog = Puppet::Resource::Catalog.new
    resources.each { |r| catalog.add_resource r }

    catalog.apply
    example.run

    catalog.clear
    described_class.clear
  end

  subject { File.read(path) }

  describe "with a single instance" do
    describe "without a version" do
      describe "with a single keyword" do
        let(:resources) do
          r = []
          r << type_class.new(
            :name     => 'app-admin/dummy',
            :use      => 'doc',
            :target   => path,
            :provider => :parsed
          )
          r
        end

        it { should have(1).lines }
        it { should match %r[^app-admin/dummy doc$] }
      end

      describe "with multiple use" do
        let(:resources) do
          r = []
          r << type_class.new(
            :name     => 'app-admin/dummy',
            :use      => ['acpi', 'sse2'],
            :target   => path,
            :provider => :parsed
          )
          r
        end

        it { should have(1).lines }
        it { should match %r[^app-admin/dummy acpi sse2$] }
      end
    end
    describe "with a version" do
      describe "with a single keyword" do
        let(:resources) do
          r = []
          r << type_class.new(
            :name     => 'app-admin/dummy',
            :use      => 'doc',
            :target   => path,
            :version  => '>=2.3.4-alpha1',
            :provider => :parsed
          )
          r
        end

        it { should have(1).lines }
        it { should match %r[^>=app-admin/dummy-2\.3\.4-alpha1 doc$] }
      end

      describe "with multiple use" do
        let(:resources) do
          r = []
          r << type_class.new(
            :name     => 'app-admin/dummy',
            :use      => ['acpi', 'sse2'],
            :target   => path,
            :version  => '>=2.3.4-alpha1',
            :provider => :parsed
          )
          r
        end

        it { should have(1).lines }
        it { should match %r[^>=app-admin/dummy-2\.3\.4-alpha1 acpi sse2$] }
      end
    end
  end
end
