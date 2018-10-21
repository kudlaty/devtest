require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user){ FactoryBot.create(:user) }
  it "should return token" do
    expect(user.token).to be_a String
    expect(user.token).to be_present
  end
  it "should find user by token" do
    user #only for create user inside db
    u = User.find_by_token(user.token)
    expect(u).to be_present
    expect(u.id).to eq user.id
  end
end
