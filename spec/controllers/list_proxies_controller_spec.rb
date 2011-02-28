require 'spec_helper'

describe ListProxiesController do
  it { should route(:put, 'lists/1/proxy').to(:action => :update, :list_id => 1) }
  it { should route(:delete, 'lists/1/proxy').to(:action => :destroy, :list_id => 1) }
  it { should route(:get, 'lists/1/archive').to(:action => :show, :list_id => 1) }
end
