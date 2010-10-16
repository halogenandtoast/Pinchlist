require 'spec_helper'

describe DashboardsController, 'routes' do
  it { should route(:get, '/dashboard').to(:action => 'show') }

  it 'should redirect if not signed in' do
    get 'show'
    response.should be_redirect
  end
end
