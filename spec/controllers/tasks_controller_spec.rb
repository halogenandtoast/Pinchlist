require 'spec_helper'

describe TasksController do
  it { should route(:post, '/lists/2/tasks').to(:action => 'create', :list_id => 2) }
end
