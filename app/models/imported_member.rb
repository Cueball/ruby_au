class ImportedMember < ApplicationRecord
  scope :uncontacted, -> { where(contacted_at: nil) }
  scope :subscribed,  -> { where(unsubscribed_at: nil) }
  scope :contactable, -> { uncontacted.subscribed }

  validates :full_name, presence: true
  validates :email, presence: true
  validates :token, presence: true, uniqueness: true

  before_validation :set_token, on: :create

  private

  def set_token
    self.token = SecureRandom.uuid
  end
end
