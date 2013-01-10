class PagesController < ApplicationController
  skip_before_filter :authenticate_user!

  def about
  end

  def legal
  end

  def help
  end

end
