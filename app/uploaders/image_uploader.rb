# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :medium do
    process :resize_to_fit => [160, 160]
  end

  version :thumb do
    process :resize_to_fit => [50, 50]
  end
end
