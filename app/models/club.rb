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

class Club < ActiveRecord::Base
end
