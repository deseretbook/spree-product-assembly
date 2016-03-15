#FactoryGirl.define do
#
#  factory :digital_order, parent: :order do |f|
#    bill_address
#    ship_address
#
#    after(:create) do |order, evaluator|
#      #create_list(:line_item, 1, order: order)
#      order.line_items.reload
#
#      create(:shipment, order: order)
#      order.shipments.reload
#
#      order.update!
#    end
#
#    factory :digital_mixed_order do |f|
#
#      order.contents.add(
#        create(:product, parts: [
#          create(:variant, digitals: [create(:digital_ebook)]),
#          create(:variant, digitals: [create(:digital_download)])
#        ]).variants_including_master.first
#      )
#      order.contents.add( create(:variant) )
#
#    end
#
#  end
#end
