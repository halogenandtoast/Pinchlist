require 'spec_helper'

describe SharesController do
  it { should route(:post, "/lists/1/shares").to(:action => :create, :list_id => 1) }
end
