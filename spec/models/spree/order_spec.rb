require 'spec_helper'

module Spree

  describe Order do

    context "order must know about bundled and unbunbled digital products" do
      let!(:order) { create(:order) }
      let(:product) { create(:product, price: 3.00) }

      before do
        ebook = create(:variant, digitals: [create(:digital_ebook)], price: 1.00)
        link  = create(:variant, digitals: [create(:digital_download)], price: 2.00)
        link2 = create(:variant, digitals: [create(:digital_download)], price: 3.00)
        product.parts << [ebook, link]
        order.contents.add(product.variants_including_master.first, 1)
        order.contents.add(link2, 2)
        order.create_download_links
      end

      it "all products must be digital" do
        order.all_digital?.should be_true
        order.some_digital?.should be_true
      end

      it "not all are books" do
        order.all_ebooks?.should be_false
        order.some_ebooks?.should be_true
      end

      it "not all are digital" do
        order.all_downloads?.should be_true
        order.some_downloads?.should be_true
      end

      it "and total items or order" do
        order.ebook_line_items.count.should be_equal(1)
        order.download_line_items.count.should be_equal(2)
        order.digital_goods_line_items.count.should be_equal(2)
        order.digital_line_items.count.should be_equal(2)
        order.physical_line_items.count.should be_equal(0)
        order.digital_links.count.should be_equal(2)
      end

      it "must count correctly amount and quantity" do
        order.digital_quantity.should be_equal(3)
        order.digital_amount.to_f.should be_equal(9.00)
      end

    end

  end
end
