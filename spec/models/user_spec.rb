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

  it "is not valid when email is not unique" do
    user = build(:user)
    duplicated_user = build(:user)

    user.save
    duplicated_user.save

    expect(duplicated_user.errors).to have_key(:email)
  end
end
