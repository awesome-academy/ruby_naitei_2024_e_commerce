class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :created_at, :updated_at

  has_one :category
  has_many :comments
end
