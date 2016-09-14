require 'rails_helper'

describe Post do
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :subtitle }
    it { should validate_presence_of :body }
    it { should belong_to :user }
  end
end
