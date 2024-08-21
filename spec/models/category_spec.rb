require "rails_helper"

RSpec.describe Category, type: :model do
  describe "validations" do
    context "when provided attributes is valid" do
      category = FactoryBot.build(:category)
      it "is valid with name and image" do
        expect(category).to be_valid
      end
    end

    context "when provided attributes is invalid" do
      it "is invalid with name" do
        category = FactoryBot.build(:category, name: "")
        expect(category).not_to be_valid
      end

      it "is invalid with image" do
        category = FactoryBot.build(:category)
        category.image.attach(
          io: File.open(Rails.root.join("spec", "fixtures", "files", "test.txt")),
          filename: "test.txt",
          content_type: "text/plain"
        )
        expect(category).not_to be_valid
        expect(category.errors[:image]).to include(I18n.t("image.image_invalid_format"))
      end
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:products).dependent(:destroy) }
    it { is_expected.to belong_to(:parent_category).class_name("Category").optional }
    it { is_expected.to have_many(:child_categories).class_name("Category").with_foreign_key(:parent_category_id).dependent(:destroy) }
    it "has one attached image" do
      expect(Category.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
    end
  end

  describe "scopes" do
    let!(:category1) { FactoryBot.create(:category, parent_category: nil, created_at: 2.days.ago) }
    let!(:category2) { FactoryBot.create(:category, parent_category: nil, created_at: 1.day.ago) }
    let!(:child_category) { FactoryBot.create(:category, parent_category: category1, created_at: 3.days.ago) }
    let!(:category_with_comments) { FactoryBot.create(:category) }
    let!(:category_with_comments1) { FactoryBot.create(:category) }
    let!(:category_without_comments) { FactoryBot.create(:category) }

    let!(:product_with_comments) { FactoryBot.create(:product, category: category_with_comments) }
    let!(:product_without_comments) { FactoryBot.create(:product, category: category_without_comments) }
    let!(:product_with_comments1) { FactoryBot.create(:product, category: category_with_comments1) }

    let!(:comment1) { FactoryBot.create(:comment, product: product_with_comments) }
    let!(:comment2) { FactoryBot.create(:comment, product: product_with_comments) }
    let!(:comment3) { FactoryBot.create(:comment, product: product_with_comments1) }
    let!(:comment4) { FactoryBot.create(:comment, product: product_with_comments1) }
    let!(:category_with_most_comments) { FactoryBot.create(:category) }
    let!(:category_with_few_comments) { FactoryBot.create(:category) }

    let!(:product_with_most_comments) { FactoryBot.create(:product, category: category_with_most_comments) }
    let!(:product_with_few_comments) { FactoryBot.create(:product, category: category_with_few_comments) }

    let!(:comment5) { FactoryBot.create(:comment, product: product_with_most_comments) }
    let!(:comment6) { FactoryBot.create(:comment, product: product_with_most_comments) }
    let!(:comment7) { FactoryBot.create(:comment, product: product_with_most_comments) }
    let!(:comment8) { FactoryBot.create(:comment, product: product_with_few_comments) }

    context "when querying with valid date range" do
      context "oldest" do
        it "orders by parent_category_id and created_at ascending" do
          expect(Category.oldest).to eq([category1, category2, category_with_comments, category_with_comments1, category_without_comments, category_with_most_comments, category_with_few_comments, child_category])
        end
      end

      context "category_by_comments" do
        it "returns categories that have products with comments by group by categories_id" do
          result = Category.category_by_comments

          expect(result).to eq([category_with_comments, category_with_comments1, category_with_most_comments, category_with_few_comments])
        end
      end

      context "order_by_comment" do
        it "orders categories by the number of comments in descending order" do
          result = Category.category_by_comments.order_by_comment
          expect(result).to eq([category_with_most_comments, category_with_comments, category_with_comments1, category_with_few_comments])
        end
      end
    end

    context "when querying with invalid or no matching date range" do
      context "oldest" do
        it "does not order by parent_category_id and created_at ascending" do
          expect(Category.oldest).not_to eq([category1, category2, child_category, category_with_comments, category_with_comments1, category_without_comments, category_with_most_comments, category_with_few_comments])
        end
      end

      context "category_by_comments" do
        it "does not return categories that have products with comments by group by categories_id" do
          result = Category.category_by_comments

          expect(result).not_to eq([category_with_comments1, category_with_most_comments, category_with_few_comments, category_with_comments])
        end
      end

      context "order_by_comment" do
        it "does not order categories by the number of comments in descending order" do
          result = Category.category_by_comments.order_by_comment
          expect(result).not_to eq([category_with_most_comments, category_with_few_comments])
        end
      end
    end
  end
end
