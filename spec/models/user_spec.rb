require 'spec_helper'

describe User do
  it { should have_many :lists }
  it { should have_many(:tasks).through(:lists) }
end

