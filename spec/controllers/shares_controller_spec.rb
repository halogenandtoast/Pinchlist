require 'spec_helper'

describe SharesController do
  it { should route(:post, "/lists/1/share").to(:action => :create, :list_id => 1) }
  it { should route(:delete, "/lists/1/share").to(:action => :destroy, :list_id => 1) }
end
