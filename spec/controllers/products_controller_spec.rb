require "rails_helper"

RSpec.describe ProductsController, type: :controller do
  let!(:category) { create(:category) }
  let!(:product1) { create(:product, name: "Product 1", description: "Description 1", price: 100.0, remain_quantity: 10, category: category) }
  let!(:product2) { create(:product, name: "Product 2", description: "Description 2", price: 200.0, remain_quantity: 20, category: category) }

  describe "GET #index" do
    context "without search params" do
      it "assigns all products and categories, and renders the index template" do
        get :index
        expect(assigns(:products)).to match_array([product1, product2])
        expect(assigns(:categories)).to match_array([category])
        expect(response).to render_template(:index)
      end
    end

    context "with search params" do
      it "assigns filtered products based on search query" do
        get :index, params: { product_list: { name_or_description: "Product 1" } }
        expect(assigns(:products)).to include(product1)
        expect(assigns(:products)).not_to include(product2)
      end
    end

    context "with filter params" do
      it "assigns filtered products based on category and price" do
        get :index, params: { category_ids: [category.id], from: 50, to: 150 }
        expect(assigns(:products)).to include(product1)
        expect(assigns(:products)).not_to include(product2)
      end
    end
  end

  describe "GET #show" do
    context "when the product exists" do
      it "assigns the requested product and renders the show template" do
        get :show, params: { id: product1.id }
        expect(assigns(:product)).to eq(product1)
        expect(assigns(:comments)).to eq(product1.comments)
        expect(response).to render_template(:show)
      end
    end

    context "when the product does not exist" do
      it "redirects to root path with an alert message" do
        get :show, params: { id: 9999 }
        expect(flash[:alert]).to eq(I18n.t("errors.product.not_found"))
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
