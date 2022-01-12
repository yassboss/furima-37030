FactoryBot.define do
  factory :notification do
    action         { 'comment' }
    checked        { 0 }
  end
end
