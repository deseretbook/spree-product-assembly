module Spree
  LineItem.class_eval do
    scope :assemblies, -> { joins(:product => :parts).uniq }

    def any_units_shipped?
      OrderInventoryAssembly.new(self).inventory_units.any? do |unit|
        unit.shipped?
      end
    end

    # Destroy and verify inventory so that units are restocked back to the
    # stock location
    def destroy_along_with_units
      self.quantity = 0
      OrderInventoryAssembly.new(self).verify
      self.destroy
    end

    # The parts that apply to this particular LineItem. Usually `product#parts`, but
    # provided as a hook if you want to override and customize the parts for a specific
    # LineItem.
    def parts
      product.parts
    end

    # check if the LineItem is an Assembly
    def assembly?
      parts.present?
    end

    # The number of the specified variant that make up this LineItem. By default, calls
    # `product#count_of`, but provided as a hook if you want to override and customize
    # the parts available for a specific LineItem. Note that if you only customize whether
    # a variant is included in the LineItem, and don't customize the quantity of that part
    # per LineItem, you shouldn't need to override this method.
    def count_of(variant)
      product.count_of(variant)
    end

    def has_digitals?
      if assembly?
        self.parts.any? {|part| part.has_digitals?}
      else
        self.variant.has_digitals?
      end
    end

    def digital?
      if assembly?
        self.parts.any? {|part| part.digital?}
      else
        self.variant.digital?
      end
    end

    def ebook?
      if assembly?
        self.parts.any? {|part| part.ebook? }
      else
        self.variant.ebook?
      end
    end

    def ebook
      if assembly?
        part_ebooks = self.parts.select {|part| part.ebook? }
        part_ebooks.map {|variant| variant.digitals.first }
      else
        self.ebook? ? self.variant.digitals.first : nil
      end
    end

    def download?
      if assembly?
        self.parts.any? {|part| part.download? }
      else
        self.variant.download?
      end
    end

    def create_download_links
      self.digital_links.delete_all

      self.parts.each do |part|
        part.digitals.each do |digital|
          self.quantity.times do
            self.digital_links.create!(digital: digital)
          end
        end
      end
    end


    private
      def update_inventory
        if self.product.assembly? && order.completed?
          OrderInventoryAssembly.new(self).verify(target_shipment)
        else
          OrderInventory.new(self.order, self).verify(target_shipment)
        end
      end
  end
end
