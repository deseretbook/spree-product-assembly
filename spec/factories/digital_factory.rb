FactoryGirl.define do

  factory :digital_download, :class => Spree::Digital do |f|
    f.variant { |p| p.association(:variant) }
    attachment_content_type 'application/octet-stream'
    attachment_file_name "#{SecureRandom.hex(5)}.epub"
  end

  factory :digital_ebook, :class => Spree::Digital do |f|
    f.variant { |p| p.association(:variant) }
    bookshelf_id SecureRandom.hex(5)
  end

end
