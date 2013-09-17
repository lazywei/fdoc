require 'spec_helper'

require 'fdoc/spec_watcher'

describe Fdoc::SpecWatcher do

  context "on rails" do
    before do
      # This should be an integration test, but for now a smoke test suffices to
      # surface obvious bugs and verify some behaviours.
      @klass = Class.new do
        def example
          Struct.new(:metadata).new(:fdoc => 'index')
        end

        def response
          Struct.new(:body, :status).new("{}", 200)
        end

        def get(action, params)
          params
        end

        def patch(action, params)
          params
        end
      end.new
      @klass.extend(Fdoc::SpecWatcher)
    end

    it 'should verify when params are a hash' do
      Fdoc::Service.should_receive(:verify!).with do |*args|
        args[2] == {:id => 1}
      end
      @klass.get(:index, {:id => 1})
    end

    it 'should verify when params are JSON' do
      Fdoc::Service.should_receive(:verify!).with do |*args|
        args[2] == {'id' => 1}
      end
      @klass.get(:index, {:id => 1}.to_json)
    end

    it "should verify when verb is patch" do
      Fdoc::Service.should_receive(:verify!).with do |*args|
        args[2] == {'id' => 1}
      end
      @klass.patch(:index, {:id => 1}.to_json)
    end
  end

  context "on sinatra" do

    before do
      # This should be an integration test, but for now a smoke test suffices to
      # surface obvious bugs and verify some behaviours.
      @klass = Class.new do
        def example
          Struct.new(:metadata).new(:fdoc => 'index')
        end

        def last_response
          Struct.new(:body, :status).new("{}", 200)
        end

        def get(action, params)
          params
        end
      end.new
      @klass.extend(Fdoc::SpecWatcher)
    end

    it 'should verify when params are a hash' do
      Fdoc::Service.should_receive(:verify!).with do |*args|
        args[2] == {:id => 1}
      end
      @klass.get("/", {:id => 1})
    end

    it 'should verify when params are JSON' do
      Fdoc::Service.should_receive(:verify!).with do |*args|
        args[2] == {'id' => 1}
      end
      @klass.get("/", {:id => 1}.to_json)
    end
  end
end
