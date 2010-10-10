require 'spec_helper'

describe DashboardsController, 'routes' do
  it { should route(:get, '/dashboard').to(:action => 'show') }
end
