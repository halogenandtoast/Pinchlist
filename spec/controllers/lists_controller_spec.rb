require 'spec_helper'

describe ListsController do
  it { should route(:post, 'lists').to(:action => :create) }
  it { should route(:delete, 'lists/1').to(:action => :destroy, :id => 1) }
end
