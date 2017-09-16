require 'rails_helper'

describe User do
  it "is valid by default" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "is not valid without an email" do
    user = User.new(email: nil)
    expect(user).to_not be_valid
  end

  it "is not valid with a duplicate email" do
    User.new(email: 'test@example.com')
    user = User.new(email: 'test@example.com')
    expect(user).to_not be_valid
  end

  it "is not valid without a password" do
    user = User.new(password: nil)
    expect(user).to_not be_valid
  end

  describe ".visible_for_user" do
    it "returns the matching users profile or visible profiles" do
      current_user = FactoryGirl.create(:user)

      visible_profiles = create_list(:user, 2, :visible)
      invisible_profiles = create_list(:user, 2)

      expect(User.visible_for_user(current_user)).to \
        match_array([*visible_profiles, current_user])
    end
  end
end
