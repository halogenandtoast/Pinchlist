class Api::BaseController < ApplicationController
  before_filter :authenticate_user!
end
