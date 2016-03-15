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

    # The number of the specified variant that make up this LineItem. By default, calls
    # `product#count_of`, but provided as a hook if you want to override and customize
    # the parts available for a specific LineItem. Note that if you only customize whether
    # a variant is included in the LineItem, and don't customize the quantity of that part
    # per LineItem, you shouldn't need to override this method.
    def count_of(variant)
      product.count_of(variant)
    end

    def digital?
      self.parts.all? {|part| part.digital?}
    end

    def some_digital?
      self.parts.any? {|part| part.digital?}
    end

    def ebook?
      self.parts.all? {|part| part.ebook? }
    end

    def some_ebooks?
      self.parts.any? {|part| part.ebook? }
    end

    def download?
      self.parts.all? {|part| part.download? }
    end

    def some_downloads?
      self.parts.any? {|part| part.download? }
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
