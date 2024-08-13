require "rails_helper"
require "active_storage_validations/matchers"

RSpec.describe Product, type: :model do
  describe "associations" do
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:cart_details).dependent(:destroy) }
    it { should belong_to(:category).optional }
    it { should have_one_attached(:image) }
  end

  describe "validations" do
    context "when validations pass" do
      let(:product) { build(:product) }

      it "validates presence of name" do
        expect(product).to validate_presence_of(:name)
      end

      it "validates presence of description" do
        expect(product).to validate_presence_of(:description)
      end

      it "validates presence of price" do
        expect(product).to validate_presence_of(:price)
      end

      it "validates numericality of price" do
        expect(product).to validate_numericality_of(:price).is_greater_than(0)
      end

      it "validates presence of remain quantity" do
        expect(product).to validate_presence_of(:remain_quantity)
      end

      it "validates numericality of remain quantity" do
        expect(product).to validate_numericality_of(:remain_quantity).only_integer.is_greater_than_or_equal_to(0)
      end

      it "validates presence of category_id" do
        expect(product).to validate_presence_of(:category_id)
      end

      it "validates image content type" do
        expect(product).to validate_content_type_of(:image).allowing("image/png", "image/jpeg")
      end

      it "validates image size" do
        expect(product).to validate_size_of(:image).less_than(Settings.max_image_data.megabytes)
      end
    end

    context "when validations fail" do
      let(:product) { build(:product, price: -10, remain_quantity: -5) }

      it "fails to validate numericality of price" do
        expect(product).not_to be_valid
        expect(product.errors[:price]).to include(I18n.t("errors.messages.greater_than", count: 0))
      end

      it "fails to validate numericality of remain quantity" do
        expect(product).not_to be_valid
        expect(product.errors[:remain_quantity]).to include(I18n.t("errors.messages.greater_than_or_equal_to", count: 0))
      end

      it "fails to validate image content type" do
        product.image.attach(io: File.open("spec/fixtures/files/test.txt"), filename: "test.txt", content_type: "text/plain")
        expect(product).not_to be_valid
        expect(product.errors[:image]).to include(I18n.t("errors.messages.content_type_invalid"))
      end
    end
  end

  describe "scopes" do
    let!(:category) { create(:category) }
    let!(:product1) { create(:product, price: 100, category: category, created_at: 2.days.ago) }
    let!(:product2) { create(:product, price: 150, category: category, created_at: 1.day.ago) }

    it ".filter_by_category_ids filters products by category ids" do
      expect(Product.filter_by_category_ids([category.id])).to include(product1, product2)
    end

    it ".filter_by_price filters products by price range" do
      expect(Product.filter_by_price(50, 150)).to include(product1, product2)
    end
  end
end
