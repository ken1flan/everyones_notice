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
  attr_accessible :name, :slug, :description
  has_many :users

  def activities_for_heatmap(
    start_date = 5.month.ago.beginning_of_month,
    end_date = Time.zone.now)

    Notice.where(created_at: [start_date..end_date]).
      select("created_at").
      joins(user: :club).merge(Club.where(id: id)).
      map {|n| n.created_at.to_i }.
      inject(Hash.new(0)){|h, tm| h[tm] += 1; h}.
      to_json
  end
end
