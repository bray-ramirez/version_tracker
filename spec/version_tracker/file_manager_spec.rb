require 'spec_helper'

describe VersionTracker::FileManager do

  before do
    File.delete('VERSION') if VersionTracker::FileManager.initialized?
  end


  describe '.initialized?' do
    context 'when no file has been created' do
      it { expect(VersionTracker::FileManager.initialized?).to be false }
    end


    context 'when file already exists' do
      before do
        VersionTracker::FileManager.write '1.0.0'
      end


      it { expect(VersionTracker::FileManager.initialized?).to be true }
    end
  end


  describe '#read' do
    context 'when no file has been created' do
      it 'raises an error' do
        expect { VersionTracker::FileManager.read }.to raise_error
      end
    end


    context 'when file already exists' do
      before do
        VersionTracker::FileManager.write '1.0.0'
      end


      it { expect(VersionTracker::FileManager.read).to eq '1.0.0' }
    end
  end


  describe '#write' do
    before do
      VersionTracker::FileManager.write '1.0.0'
    end


    it { expect(File.exist? 'VERSION').to be true }
    it { expect(File.read 'VERSION').to eq '1.0.0' }
  end

end
