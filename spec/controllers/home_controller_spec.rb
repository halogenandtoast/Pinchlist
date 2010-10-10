require 'spec_helper'

describe HomeController, 'routes' do
  it { should route(:get, '/').to(:action => 'index') }
end
