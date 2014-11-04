# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

# Club

default_group = Club.where(slug: "default")
if default_group.blank?
  Club.create(
    name: "default",
    slug: "default",
    description: "default group"
  )
end
