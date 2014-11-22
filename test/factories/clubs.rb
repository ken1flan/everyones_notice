FactoryGirl.define do
  factory :club do
    sequence :name do
      |n| "clubname#{n}"
    end
    sequence :slug do
      |n| "slug#{n}"
    end
    description "description"
  end
end
