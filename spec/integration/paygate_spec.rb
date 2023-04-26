# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Paygate do
  it 'can load gem' do
    expect(described_class).to_not be_nil
  end
end
