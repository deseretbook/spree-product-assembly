require 'spec_helper'

module Spree

  describe Order do
    let!(:order) { create(:order) }
    let(:product) { create(:product) }

    context "order must know about mixed digital products" do

      before do
        ebook = create(:variant, digitals: [create(:digital_ebook)])
        link = create(:variant, digitals: [create(:digital_download)])
        product.parts << [ebook, link]
        order.contents.add(product.variants_including_master.first)
        order.contents.add(create(:variant, digitals: [create(:digital_download)]))
      end

      it "and all products must be digital" do
        order.all_digital?.should be_true
        order.some_digital?.should be_true
      end

      it "not all are books" do
        order.all_ebooks?.should be_false
        order.some_ebooks?.should be_true
      end

      it "not all are digital" do
        order.all_downloads?.should be_false # ebook isn't a download?
        order.some_downloads?.should be_true
      end

      it "and total items or order" do
        order.ebook_line_items.count.should be_equal(1)
        # download on parts need ALL be download.. ebook isn't a dowload(?)
        order.download_line_items.count.should be_equal(1)
        order.digital_goods_line_items.count.should be_equal(2)
        order.digital_line_items.count.should be_equal(2)
        order.physical_line_items.count.should be_equal(0)
      end
    end

  end
end
