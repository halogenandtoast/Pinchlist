require 'spec_helper'

describe PagesController do

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
  end

  describe "GET 'legal'" do
    it "should be successful" do
      get 'legal'
      response.should be_success
    end
  end
end
