require 'spec_helper'
require 'version_tracker/command_line'


describe VersionTracker::CommandLine do

  before do
    File.delete('VERSION') if VersionTracker::FileManager.initialized?
  end


  describe '#execute' do

    context 'with invalid args' do
      it "returns 'Invalid command' message and status of 1" do
        expect(VersionTracker::CommandLine.new.execute 'invalid').to eq ['Invalid command', 1]
      end
    end


    context 'when command is init' do
      context 'without value' do
        before do
          VersionTracker::CommandLine.new.execute ['init']
        end


        it { expect(VersionTracker::FileManager.read).to eq '0.0.0' }
      end


      context 'with value' do
        before do
          VersionTracker::CommandLine.new.execute ['init', '1.1.0']
        end


        it { expect(VersionTracker::FileManager.read).to eq '1.1.0' }
      end
    end


    context 'when command is read' do
      before do
        VersionTracker::FileManager.write '1.2.3'
      end


      it { expect(VersionTracker::CommandLine.new.execute ['read']).to include '1.2.3' }
    end


    context 'when command is bump' do
      context 'without part' do
        before do
          VersionTracker::FileManager.write '1.2.3'
          VersionTracker::CommandLine.new.execute ['bump']
        end


        it { expect(VersionTracker::FileManager.read).to eq '1.2.4' }
      end


      context 'with patch part' do
        before do
          VersionTracker::FileManager.write '1.2.3'
          VersionTracker::CommandLine.new.execute ['bump', 'patch']
        end


        it { expect(VersionTracker::FileManager.read).to eq '1.2.4' }
      end


      context 'with minor part' do
        before do
          VersionTracker::FileManager.write '1.2.3'
          VersionTracker::CommandLine.new.execute ['bump', 'minor']
        end


        it { expect(VersionTracker::FileManager.read).to eq '1.3.0' }
      end


      context 'with patch part' do
        before do
          VersionTracker::FileManager.write '1.2.3'
          VersionTracker::CommandLine.new.execute ['bump', 'major']
        end


        it { expect(VersionTracker::FileManager.read).to eq '2.0.0' }
      end


      context 'with invalid part' do
        before do
          VersionTracker::FileManager.write '1.2.3'
        end


        it { expect(VersionTracker::CommandLine.new.execute ['bump', 'invalid']).to eq ['Invalid part', 1] }
      end
    end


    context 'when command is tag' do
      before do
        `git checkout master`
        VersionTracker::FileManager.write '1.2.0'
        VersionTracker::CommandLine.new.execute ['tag']
      end

      it { expect(`git tag -l`).to include '1.2.0' }
    end


    context 'with release option' do
      before :all do
        `git checkout master`
        VersionTracker::FileManager.write '1.2.0'
        VersionTracker::CommandLine.new.execute ['read'], {:release => true}
      end


      it { expect(`git log -1 --pretty=format:'%s'`).to include 'Set Version to 1.2.0' }
      it { expect(`git rev-parse --abbrev-ref HEAD`).to include 'release/1.2.0' }
    end


    context 'with messsage option' do
      before do
        `git checkout master`
        VersionTracker::FileManager.write '2.2.0'
        VersionTracker::CommandLine.new.execute ['read'], {:release => true, :message => 'Test Commit Message'}
      end


      it { expect(`git log -1 --pretty=format:'%s'`).to include 'Test Commit Message' }
    end



    context 'with push option' do
      before :all do
        `git checkout master`
        VersionTracker::FileManager.write '3.0.0'
        VersionTracker::CommandLine.new.execute ['read'], {:push => true}
      end


      it { expect(`git log -1 --pretty=formst:'%s'`).to include 'Set Version to 3.0.0' }
      it { expect(`git rev-parse --abbrev-ref HEAD`).to include 'master' }
    end

  end

end
