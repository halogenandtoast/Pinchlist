class ArchivesController < ApplicationController
  before_filter :authenticate_user!
end
