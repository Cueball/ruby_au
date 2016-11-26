class JoiningMember
  include ActiveModel::Model
  include Virtus.model

  def initialize(user:)
    @user = user
    set_attributes_from_model
  end

  attr_accessor :user

  # User Attributes
  attribute :email, String
  attribute :password, String

  # UserProfile Attributes
  attribute :preferred_name, String
  attribute :full_name, String
  attribute :biography, String
  attribute :github_url, String
  attribute :twitter_url, String
  attribute :website_url, String
  attribute :display_profile, Boolean

  # User Validations
  validates :user, :email, :password, presence: true

  # UserProfile Validations
  validates :preferred_name, :full_name, presence: true
  validates :display_profile, inclusion: { in: [true, false] }

  validate :validate_user

  def save
    return false unless valid?

    User.transaction do
      assign_profile_params
      @user.save!
      @profile.save!
    end
  end

  private

  def set_attributes_from_model
    @profile = user.profile || user.build_profile
  end

  def assign_user_params
    @user.attributes = { email: email, password: password }
  end

  def assign_profile_params
    @profile.attributes = {
      preferred_name: preferred_name,
      full_name: full_name,
      biography: biography,
      github_url: github_url,
      twitter_url: twitter_url,
      website_url: website_url,
      display_profile: display_profile
    }
  end

  def validate_user
    assign_user_params

    promote_errors(user.errors) if user.invalid?
  end

  def promote_errors(child_errors)
    child_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end
end
