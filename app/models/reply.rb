class Reply < ActiveRecord::Base
  belongs_to :user
  belongs_to :notice

  validates :notice_id,
    presence: true,
    numericality: { allow_blank: true, greater_than: 0 }
  validates :body,
    presence: true
  validates :user_id,
    presence: true,
    numericality: { allow_blank: true, greater_than: 0 }
end
