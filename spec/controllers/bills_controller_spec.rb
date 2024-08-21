require "rails_helper"

RSpec.describe BillsController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  let(:bill) { FactoryBot.create(:bill, user: user) }
  let(:cart) { FactoryBot.create(:cart, user: user) }
  let(:cart_details) { cart.cart_details }

  shared_context "signed in user" do
    before do
      sign_in user
      allow_any_instance_of(BillsController).to receive(:load_current_user_cart) do
        controller.instance_variable_set(:@cart_details, cart_details)
        controller.instance_variable_set(:@cart, cart)
      end
    end
  end

  shared_context "signed out user" do
    before do
      sign_out user
    end
  end

  describe "GET #index" do
    context "when the user is signed in" do
      include_context "signed in user"
      it "assigns bills get all bill" do
        get :index
        expect(assigns(:bills)).to eq([bill])
      end
      it "assigns bills render template bills" do
        get :index
        expect(response).to render_template(:index)
      end
      it "assigns an empty array when there are no bills" do
        allow(user).to receive(:bills).and_return(Bill.none)
        get :index
        expect(assigns(:bills)).to eq([])
      end
    end
    context "when the user is not signed in" do
      include_context "signed out user"
      it "redirects to the sign-in page" do
        get :index
        expect(response).to redirect_to(new_user_session_path(locale: nil))
      end
    end
  end

  describe "GET #show" do
    context "when the user is signed in" do
      include_context "signed in user"
      context "when the bill is found" do
        before do
          get :show, params: { id: bill.id }
        end
        it "assigns bill and gets the right bill" do
          expect(assigns(:bill)).to eq bill
        end

        it "assigns bill details and renders the right bill details" do
          expect(assigns(:bill_details)).to eq bill.bill_details
        end

        it "assigns bill and bill_details and renders the show template" do
          expect(response).to render_template :show
        end
      end
      context "when the bill is not found" do
        before do
          get :show, params: { id: 0 }
        end

        it "flashes an alert message" do
          expect(flash[:alert]).to eq I18n.t("errors.bill.not_found")
        end

        it "redirects to the root path" do
          expect(response).to redirect_to root_path
        end
      end
    end
    context "when the user is not signed in" do
      include_context "signed out user"
      it "redirects to the sign-in page" do
        get :show, params: { id: bill.id }
        expect(response).to redirect_to(new_user_session_path(locale: nil))
      end
    end
  end

  describe "POST #create" do
    context "when the user is signed in" do
      include_context "signed in user"
      context "when the bill is saved successfully" do
        it "creates a new bill " do
          post :create, params: { bill: bill.attributes }
          expect(assigns(:bill)).to be_a(Bill)
        end

        it "initiates Stripe session " do
          post :create, params: { bill: bill.attributes }
          expect(response).to redirect_to(assigns(:session).url)
        end
      end

      context "when the bill is saved unsuccessfully" do
        let(:invalid_bill_params) { { amount: nil, description: 'Invalid Bill' } }
        it 'does not create a new bill' do
          expect {
            post :create, params: { bill: invalid_bill_params  }
          }.not_to change(Bill, :count)
        end

        it "renders the new template" do
          post :create, params: { bill: invalid_bill_params }
          expect(response).to render_template(:new)
        end

        it "renders the new template with unprocessable_entity status" do
          post :create, params: { bill: invalid_bill_params }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "when the user is not signed in" do
      include_context "signed out user"
      it "redirects to the sign-in page" do
        post :create, params: { bill: FactoryBot.attributes_for(:bill) }
        expect(response).to redirect_to(new_user_session_path(locale: nil))
      end
    end
  end

  describe "POST #repayment" do
    context "when the user is signed in" do
      include_context "signed in user"
      context "when the bill is found" do
        it "initiates Stripe session for the bill details" do
          post :repayment, params: { bill_id: bill.id }
          expect(response).to redirect_to(assigns(:session).url)
        end
      end
      context "when the bill is not found" do
        it "redirects to bills_url" do
          post :repayment, params: { bill_id: 0 }

          expect(response).to redirect_to(bills_url)
        end
        it "redirects to bills_url with a flash message" do
          post :repayment, params: { bill_id: 0 }

          expect(flash[:danger]).to eq(I18n.t("not_found", model: I18n.t("order.id")))
        end
      end
    end
    context "when the user is not signed in" do
      include_context "signed out user"
      it "redirects to the sign-in page" do
        post :repayment, params: { bill_id: bill.id }
        expect(response).to redirect_to(new_user_session_path(locale: nil))
      end
    end
  end

  describe "PATCH #update_total" do
    context "when the user is signed in" do
      include_context "signed in user"
      context "when a voucher is applied" do
        before do
          patch :update_total, params: { voucher_id: bill.voucher.id }, format: :turbo_stream
        end
        it "calculates the total discount correctly" do
          expected_value = cart.total - cart.total * bill.voucher.discount
          expect(assigns(:total_discount)).to eq(expected_value)
        end
        it "calculates the discount correctly" do
          expected_value = bill.voucher.discount * Settings.digit_100
          expect(assigns(:discount_voucher)).to eq(expected_value)
        end
        it "renders the turbo_stream update_total partial" do
          expect(response).to render_template(partial: "bills/_update_total")
        end
      end
      context "when no voucher is applied" do
        before do
          post :update_total, params: { voucher_id: nil }, format: :turbo_stream
        end
        it "bill total after discount not change and base on cart total" do
          expect(assigns(:total_discount)).to eq(cart.total)
        end
        it "discount will nil and no discount for bill" do
          expect(assigns(:discount_voucher)).to be_nil
        end
        it "still renders the turbo_stream update_total partial" do
          expect(response).to render_template(partial: "bills/_update_total")
        end
      end
    end
    context "when the user is not signed in" do
      include_context "signed out user"
      it "redirects to the sign-in page" do
        patch :update_total, params: { voucher_id: bill.voucher.id }, format: :turbo_stream
        expect(response).to redirect_to(new_user_session_path(locale: nil))
      end
    end
  end
end

RSpec.describe Admin::BillsController, type: :controller do
  let(:admin) { FactoryBot.create(:user, admin: true) }
  let(:user) { FactoryBot.create(:user) }
  let(:bill) { FactoryBot.create(:bill) }
  let(:voucher) {FactoryBot.create(:voucher)}

  shared_context "signed in admin" do
    before do
      sign_in admin
    end
  end

  shared_context "signed in user" do
    before do
      sign_in user
    end
  end

  describe "GET #index" do
    context "when the user is admin" do
      include_context "signed in admin"
      before do
        get :index
      end
      it "assigns bills get all bill" do
        expect(assigns(:bills)).to eq([bill])
      end
      it "assigns an empty array when there are no bills" do
        allow(user).to receive(:bills).and_return(Bill.none)
        expect(assigns(:bills)).to eq([])
      end
      it "assigns bills render template bills" do
        expect(response).to render_template(:index)
      end
      it "assigns bills get all voucher" do
        expect(assigns(:vouchers)).to eq([voucher])
      end
    end
    context "when the user is not admin" do
      include_context "signed in user"
      it "redirects to the sign-in page" do
        get :index
        expect(response).to redirect_to(products_path)
      end
    end
  end

  describe "PATCH #update_status" do
    context "when the user is admin" do
      include_context "signed in admin"
      context "when the update is successful" do
        before do
          patch :update_status, params: { id: bill.id, bill: { status: "completed" } }
        end
        it "updates the bill's status" do
          expect(bill.reload.status).to eq("completed")
        end
        it "sets a flash success message" do
          expect(flash.now[:success]).to eq(I18n.t("admin.view.bill_updated_successfully"))
        end

        it "redirects to the show page" do
          expect(response).to redirect_to(bill_path(bill))
        end
      end
      context "when the update fails" do
        before do
          allow_any_instance_of(Bill).to receive(:update).and_return(false)
          patch :update_status, params: { id: bill.id, bill: { status: "invalid_status" } }
        end

        it "does not update the bill's status" do
          expect(bill.reload.status).not_to eq("invalid_status")
        end

        it "sets a flash danger message" do
          expect(flash.now[:danger]).to eq(I18n.t("admin.view.bill_update_failed"))
        end

        it "renders the show template" do
          expect(response).to render_template(:show)
        end

        it "returns status unprocessable_entity" do
          expect(response.status).to eq(422)
        end
      end
    end
    context "when the user is not admin" do
      include_context "signed in user"
      it "redirects to the sign-in page" do
        get :index
        expect(response).to redirect_to(products_path)
      end
    end
  end
end
