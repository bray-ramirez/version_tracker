require 'spec_helper'
require 'rake'

describe 'version_tracker rake task' do

  before :all do
    load File.expand_path('../../../lib/tasks/version_tracker.rake', __FILE__)
  end


  shared_examples 'read value' do
    it { expect(File.read 'VERSION').to eq expected }
  end


  describe 'version_tracker:initialize' do
    before :all do
      File.delete('VERSION') if VersionTracker::FileManager.initialized?
      Rake::Task['version_tracker:initialize'].invoke
    end


    it { expect(File.exist? 'VERSION').to be true }

    it_behaves_like 'read value' do
      let(:expected){ '0.0.0' }
    end
  end


  describe 'version_tracker:current_version' do
    it 'is a pending example'
  end


  describe 'version_tracker:bump_major' do
    before :all do
      File.delete('VERSION') if VersionTracker::FileManager.initialized?
      VersionTracker::Bumper.new.init '0.2.1'
      Rake::Task['version_tracker:bump_major'].invoke
    end

    it_behaves_like 'read value' do
      let(:expected){ '1.0.0' }
    end
  end


  describe 'version_tracker:bump_minor' do
    before :all do
      File.delete('VERSION') if VersionTracker::FileManager.initialized?
      VersionTracker::Bumper.new.init '2.3.2'
      Rake::Task['version_tracker:bump_minor'].invoke
    end

    it_behaves_like 'read value' do
      let(:expected){ '2.4.0' }
    end
  end


  describe 'version_tracker:bump_patch' do
    before :all do
      File.delete('VERSION') if VersionTracker::FileManager.initialized?
      VersionTracker::Bumper.new.init '2.3.2'
      Rake::Task['version_tracker:bump_patch'].invoke
    end

    it_behaves_like 'read value' do
      let(:expected){ '2.3.3' }
    end
  end

end
