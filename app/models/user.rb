class User < ApplicationRecord
  enum gender: {
    female: 0,
    male: 1,
    other: 2
  }

  has_many :bills, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :wishlist_products, through: :wishlists, source: :product

  has_many :sender_relationship, classname: Chat.name,
            foreign_key: :sender_id, dependent: :destroy
  has_many :receiver_relationship, classname: Chat.name,
            foreign_key: :receiver_id, dependent: :destroy
  has_many :senders, through: :sender_relationship, source: :sender
  has_many :receivers, through: :receiver_relationship, source: :receiver

  has_one_attached :avatar
  has_secure_password
end
