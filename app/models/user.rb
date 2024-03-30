class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, uniqueness: true, length: { minimum: 2, maximum: 20 }
  validates :introduction, length: { maximum: 50 }

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
         
  has_one_attached :profile_image

  def get_profile_image(width = 100, height = 100)
    unless profile_image.attached?
      default_image_path = Rails.root.join('app/assets/images/default-image.jpg')
      profile_image.attach(io: File.open(default_image_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize: "#{width}x#{height}").processed
  end
end