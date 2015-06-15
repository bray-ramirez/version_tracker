require 'spec_helper'

describe VersionTracker::Bumper do

  before do
    File.delete('VERSION') if VersionTracker::FileManager.initialized?
  end


  shared_examples 'read version' do
    it { expect(VersionTracker::FileManager.read).to eq expected }
  end


  shared_examples 'read value' do
    it { expect(value).to eq expected }
  end


  describe '.new' do
    let(:version_tracker){ VersionTracker::Bumper.new }


    context 'without VERSION File' do
      it_behaves_like 'read value' do
        let(:value){ version_tracker.version }
        let(:expected){ '0.0.0' }
      end

      it_behaves_like 'read value' do
        let(:value){ version_tracker.parts[:major] }
        let(:expected){ 0 }
      end

      it_behaves_like 'read value' do
        let(:value){ version_tracker.parts[:minor] }
        let(:expected){ 0 }
      end

      it_behaves_like 'read value' do
        let(:value){ version_tracker.parts[:patch] }
        let(:expected){ 0 }
      end
    end


    context 'with VERSION File' do
      before do
        VersionTracker::FileManager.write '1.2.3'
      end

      it_behaves_like 'read value' do
        let(:value){ version_tracker.version }
        let(:expected){ '1.2.3' }
      end

      it_behaves_like 'read value' do
        let(:value){ version_tracker.parts[:major] }
        let(:expected){ 1 }
      end

      it_behaves_like 'read value' do
        let(:value){ version_tracker.parts[:minor] }
        let(:expected){ 2 }
      end

      it_behaves_like 'read value' do
        let(:value){ version_tracker.parts[:patch] }
        let(:expected){ 3 }
      end
    end
  end


  describe '#init' do
    context 'with version parameter' do
      before do
        VersionTracker::Bumper.new.init '1.2.3'
      end


      it_behaves_like 'read version' do
        let(:expected){ '1.2.3' }
      end
    end


    context 'without version parameter' do
      before do
        VersionTracker::Bumper.new.init
      end


      it_behaves_like 'read version' do
        let(:expected){ '0.0.0' }
      end
    end
  end


  describe '#bump' do
    let(:version_tracker){ VersionTracker::Bumper.new }


    context 'withou VERSION File initialized' do
      it 'raises an error' do
        expect { version_tracker.bump }.to raise_error
      end
    end


    context 'without parameters' do
      before do
        version_tracker.init '1.2.3'
        version_tracker.bump
      end


      it_behaves_like 'read version' do
        let(:expected){ '1.2.4' }
      end
    end


    context 'with value option only' do
      before do
        version_tracker.init '1.2.3'
        version_tracker.bump :value => 9
      end


      it_behaves_like 'read version' do
        let(:expected){ '1.2.9' }
      end
    end


    context 'with options' do
      context 'with major part parameter' do
        before do
          version_tracker.init '1.2.3'
          version_tracker.bump :part => :major
        end


        it_behaves_like 'read version' do
          let(:expected){ '2.0.0' }
        end
      end


      context 'with major part and value parameters' do
        before do
          version_tracker.init '1.2.3'
          version_tracker.bump :part => :major, :value => 5
        end


        it_behaves_like 'read version' do
          let(:expected){ '5.0.0' }
        end
      end


      context 'with minor part parameter' do
        before do
          version_tracker.init '1.2.3'
          version_tracker.bump :part => :minor
        end


        it_behaves_like 'read version' do
          let(:expected){ '1.3.0' }
        end
      end


      context 'with minor part and value parameters' do
        before do
          version_tracker.init '1.2.3'
          version_tracker.bump :part => :minor, :value => 5
        end


        it_behaves_like 'read version' do
          let(:expected){ '1.5.0' }
        end
      end
    end


    context 'with patch part parameter' do
      before do
        version_tracker.init '1.2.3'
        version_tracker.bump :part => :patch
      end


      it_behaves_like 'read version' do
        let(:expected){ '1.2.4' }
      end
    end


    context 'with patch part and value parameters' do
      before do
        version_tracker.init '1.2.3'
        version_tracker.bump :part => :patch, :value => 5
      end


      it_behaves_like 'read version' do
        let(:expected){ '1.2.5' }
      end
    end
  end

end
