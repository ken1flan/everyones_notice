# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tag < ActiveRecord::Base
  has_many :notice_tags
  has_many :notices, through: :notice_tags

  validates :name,
            presence: true,
            length: { maximum: 32 },
            format: { with: /\A[^,]+$\Z/ }
end
