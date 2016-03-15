FactoryGirl.define do
  factory :digital_link, :class => Spree::DigitalLink do |f|
    f.digital { |p| p.association(:digital_download) }
    f.line_item { |p| p.association(:line_item) }
  end
end
