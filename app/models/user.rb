class User < ApplicationRecord
  # Include devise modules. Others available are:
  # :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :confirmable, :trackable

  has_many :memberships, dependent: :destroy

  validates :full_name, presence: true
  validates :address, presence: true

  def active_for_authentication?
    super && deactivated_at.nil?
  end

  def deactivated?
    deactivated_at.present?
  end

  def manual_confirmation!
    self.confirmed_at ||= Time.current
    save!

    after_confirmation
  end

  protected

  def after_confirmation
    if email_previously_changed?
      update_mailing_list_email_addresses
    else
      set_up_mailing_list_flags
    end

    return if memberships.current.any?

    memberships.create joined_at: Time.current
  end

  def set_up_mailing_list_flags
    MailingList::Setup.call self
  end

  def update_mailing_list_email_addresses
    # rubocop:disable Rails/FindEach
    MailingList.all.each do |list|
      next unless mailing_lists[list.name] == "true"

      MailingList::Update.call self, list
    end
    # rubocop:enable Rails/FindEach
  end
end
