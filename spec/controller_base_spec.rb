require 'webrick'
require 'controller_base'
require_relative '../app/models/cat'

describe ControllerBase do
  before(:all) do
    class CatsController < ControllerBase
      def index
        @cats = Cat.all
      end
    end
  end
  after(:all) { Object.send(:remove_const, "CatsController") }

  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  let(:cats_controller) { CatsController.new(req, res) }

  describe "#render_content" do
    before(:each) do
      cats_controller.render_content "somebody", "text/html"
    end

    it "sets the response content type" do
      cats_controller.res.content_type.should == "text/html"
    end

    it "sets the response body" do
      cats_controller.res.body.should == "somebody"
    end

    describe "#already_built_response?" do
      let(:cats_controller2) { CatsController.new(req, res) }

      it "is false before rendering" do
        cats_controller2.already_built_response?.should be false
      end

      it "is true after rendering content" do
        cats_controller2.render_content "sombody", "text/html"
        cats_controller2.already_built_response?.should be true
      end

      it "raises an error when attempting to render twice" do
        cats_controller2.render_content "sombody", "text/html"
        expect do
          cats_controller2.render_content "sombody", "text/html"
        end.to raise_error
      end
    end
  end

  describe "#redirect" do
    before(:each) do
      cats_controller.redirect_to("http://www.google.com")
    end

    it "sets the header" do
      cats_controller.res.header["location"].should == "http://www.google.com"
    end

    it "sets the status" do
      cats_controller.res.status.should == 302
    end

    describe "#already_built_response?" do
      let(:cats_controller2) { CatsController.new(req, res) }

      it "is false before rendering" do
        cats_controller2.already_built_response?.should be false
      end

      it "is true after rendering content" do
        cats_controller2.redirect_to("http://google.com")
        cats_controller2.already_built_response?.should be true
      end

      it "raises an error when attempting to render twice" do
        cats_controller2.redirect_to("http://google.com")
        expect do
          cats_controller2.redirect_to("http://google.com")
        end.to raise_error
      end
    end
  end

  describe '#render' do
    before(:each) do
      cats_controller.render(:index)
    end

    it "renders the html of the index view" do
      cats_controller.res.body.should include("ALL THE CATS")
      cats_controller.res.body.should include("<h1>")
      cats_controller.res.content_type.should == "text/html"
    end

    describe "#already_built_response?" do
      let(:cats_controller3) { CatsController.new(req, res) }

      it "is false before rendering" do
        cats_controller3.already_built_response?.should be false
      end

      it "is true after rendering content" do
        cats_controller3.index
        cats_controller3.render(:index)
        cats_controller3.already_built_response?.should be true
      end

      it "raises an error when attempting to render twice" do
        cats_controller3.render(:index)
        expect do
          cats_controller3.render(:index)
        end.to raise_error
      end

      it "captures instance variables from the controller" do
        cats_controller3.index
        cats_controller3.render(:index)
        expect(cats_controller3.res.body).to include("Breakfast")
      end
    end
  end
end
