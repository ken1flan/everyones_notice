# == Schema Information
#
# Table name: clubs
#
#  id          :integer          not null, primary key
#  name        :string(128)      not null
#  slug        :string(64)       not null
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

FactoryGirl.define do
  factory :club do
    sequence :name do |n|
      "clubname#{n}"
    end
    sequence :slug do |n|
      "slug#{n}"
    end
    description 'description'
  end
end
