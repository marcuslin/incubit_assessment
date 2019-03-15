require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    expect(build(:user)).to be_valid
  end

  it "is not valid with wrong email format" do
    expect(build(:invalid_email)).to_not be_valid
  end

  it "is not valid with wrong password length" do
    expect(build(:invalid_password)).to_not be_valid
  end

  it "is not valid with wrong password confirmation" do
    expect(build(:invalid_confirmation)).to_not be_valid
  end
end
