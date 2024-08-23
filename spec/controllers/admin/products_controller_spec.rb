require "rails_helper"

RSpec.describe Admin::ProductsController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let!(:product) { create(:product) }

  before do
    sign_in admin
    allow_any_instance_of(AdminController).to receive(:require_admin).and_return(true)
  end

  describe "GET #index" do
    it "assigns @products and renders the index template" do
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:products)).to be_present
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "assigns a new product and renders the new template" do
      get :new
      expect(assigns(:product)).to be_a_new(Product)
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    let(:category) { create(:category) }

    context "with valid attributes" do
      let(:valid_product_params) { attributes_for(:product).merge(category_id: category.id) }

      it "creates a new product and redirects to the index page" do
        expect {
          post :create, params: { product: valid_product_params }
          puts assigns(:product).errors.full_messages unless assigns(:product).persisted?
        }.to change(Product, :count).by(1)
        expect(flash[:success]).to eq(I18n.t("admin.products.create.success"))
        expect(response).to redirect_to(admin_products_path)
      end
    end

    context "with invalid attributes" do
      let(:invalid_product_params) { attributes_for(:product, name: nil) }

      it "does not create a new product and re-renders the new template" do
        expect {
          post :create, params: { product: invalid_product_params }
        }.to_not change(Product, :count)
        expect(flash.now[:danger]).to eq(I18n.t("admin.products.create.fail"))
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "assigns the requested product and renders the edit template" do
      get :edit, params: { id: product.id }
      expect(assigns(:product)).to eq(product)
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates the product and redirects to the index page" do
        patch :update, params: { id: product.id, product: { name: "Updated Name" } }
        expect(product.reload.name).to eq("Updated Name")
        expect(flash[:success]).to eq(I18n.t("admin.products.edit.success"))
        expect(response).to redirect_to(admin_products_path)
      end
    end

    context "with invalid attributes" do
      it "does not update the product and re-renders the edit template" do
        patch :update, params: { id: product.id, product: { name: nil } }
        expect(flash.now[:danger]).to eq(I18n.t("admin.products.edit.fail"))
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the product and redirects to the index page" do
      expect {
        delete :destroy, params: { id: product.id }
      }.to change(Product, :count).by(-1)
      expect(flash[:success]).to eq(I18n.t("admin.products.destroy.success"))
      expect(response).to redirect_to(admin_products_path)
    end
  end
end
