class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
         
  has_one_attached :profile_image

  def get_profile_image
    unless profile_image.attached?
      default_image_path = Rails.root.join('app/assets/images/default-image.jpg')
      profile_image.attach(io: File.open(default_image_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_fill: [100, 100]).processed
  end
end