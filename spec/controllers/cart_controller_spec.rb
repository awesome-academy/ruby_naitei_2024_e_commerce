require "rails_helper"

RSpec.describe CartController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  let!(:product) { FactoryBot.create(:product, remain_quantity: 10) }
  let!(:cart) { FactoryBot.create(:cart, user: user) }
  let!(:cart_details) { cart.cart_details }
  shared_context "signed in user" do
    before do
      sign_in user
      allow_any_instance_of(CartController).to receive(:load_current_user_cart) do
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

  describe "POST #create" do
    context "when user is signed in" do
      include_context "signed in user"
      context "when product is valid" do
        before do
          post :create, params: { product_id: product.id }
        end
        it "returns product" do
          expect(assigns(:product)).to eq product
        end

        context "when quantity is invalid" do
          before :each do
            post :create, params: { product_id: product.id, quantity: 0 }
          end

          it_behaves_like "flash danger message", "cart.add_failed"
          it_behaves_like "redirect to path", "root_path"
        end

        context "when quantity exceeds product remain quantity" do
          before :each do
            post :create, params: { product_id: product.id, quantity: 11 }
          end

          it_behaves_like "flash danger message", "cart.add_failed"
          it_behaves_like "redirect to path", "root_path"
        end

        context "when adding a product to the cart successfully" do
          before :each do
            post :create, params: { product_id: product.id, quantity: 3 }
          end
          context "creates a new cart detail" do
            it "adds successfully" do
              expect(cart_details.find_by(product_id: product.id).quantity).to eq(3)
            end
            it_behaves_like "flash success message", "cart.add_success"
            it "redirect to cart path" do
              expect(response).to redirect_to cart_path(user)
            end
          end

          context "adds into an existing cart detail" do
            it "adds successfully" do
              post :create, params: { product_id: product.id, quantity: 3 }
              expect(cart_details.find_by(product_id: product.id).quantity).to eq(6)
            end
            it_behaves_like "flash success message", "cart.add_success"
            it "redirect to cart path" do
              expect(response).to redirect_to cart_path(user)
            end
          end
        end
      end

      context "when product is invalid" do
        before :each do
          post :create, params: { product_id: 0 }
        end

        it_behaves_like "flash danger message", "product.is_nil"
        it_behaves_like "redirect to path", "root_path"
      end
    end

    context "when user is not signed in" do
      include_context "signed out user"
      it "redirects to sign-in page" do
        post :create
        expect(response).to redirect_to(new_user_session_path(locale: nil))
      end
    end
  end

  describe "PATCH #update" do
    context "when user is signed in" do
      include_context "signed in user"
      context "when product is valid" do
        before do
          patch :update, params: { id: cart.id, product_id: cart_details.first.product_id }
        end
        it "returns product" do
          expect(assigns(:product)).to eq cart_details.first.product
        end

        context "when current cart detail is valid" do
          before do
            patch :update, params: { id: cart.id, product_id: cart_details.first.product_id }
          end

          it "return current cart detail" do
            current_cart_detail = cart_details.find_by(product_id: cart_details.first.product_id)
            expect(assigns(:current_cart_detail)).to eq current_cart_detail
          end

          context "when quantity is invalid" do
            before :each do
              patch :update, params: { id: cart.id, product_id: cart_details.last.product_id, quantity: -1 }
            end

            it_behaves_like "flash danger message", "cart.update_failed"
            it "redirects to cart path" do
              expect(response).to redirect_to(cart_path(user))
            end
          end

          context "when quantity exceeds product remain quantity" do
            before :each do
              patch :update, params: { id: cart.id, product_id: cart_details.last.product_id, quantity: 1000 }
            end

            it_behaves_like "flash danger message", "cart.update_failed"
            it "redirects to cart path" do
              expect(response).to redirect_to(cart_path(user))
            end
          end

          context "when quantity is positive and update successfully" do
            before :each do
              post :create, params: { product_id: product.id, quantity: 3 }
              patch :update, params: { id: cart.id, product_id: product.id, quantity: 1 }
            end

            it "updates successfully" do
              expect(cart_details.find_by(product_id: product.id).quantity).to eq(1)
            end
            it_behaves_like "flash success message", "cart.update_success"
            it "redirects to cart path" do
              expect(response).to redirect_to(cart_path(user))
            end
          end

          context "when quantity is 0 and update successfully" do
            before :each do
              post :create, params: { product_id: product.id, quantity: 3 }
              patch :update, params: { id: cart.id, product_id: product.id, quantity: 0 }
            end

            it "updates successfully" do
              expect(cart_details.find_by(product_id: product.id)).to eq nil
            end
            it_behaves_like "flash success message", "cart.update_success"
            it "redirects to cart path" do
              expect(response).to redirect_to(cart_path(user))
            end
          end
        end

        context "when current cart detail is invalid" do
          before do
            patch :update, params: { id: cart.id, product_id: cart_details.first.product_id }
          end

          it_behaves_like "flash danger message", "cart_detail.is_nil"
          it_behaves_like "redirect to path", "root_path"
        end
      end

      context "when product is invalid" do
        before :each do
          patch :update, params: { id: cart.id, product_id: 0 }
        end

        it_behaves_like "flash danger message", "product.is_nil"
        it_behaves_like "redirect to path", "root_path"
      end
    end

    context "when user is not signed in" do
      include_context "signed out user"
      it "redirects to sign-in page" do
        patch :update, params: { id: cart.id, product_id: 1 }
        expect(response).to redirect_to(new_user_session_path(locale: nil))
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is signed in" do
      include_context "signed in user"

      context "when cart detail is invalid" do
        before do
          delete :destroy, params: { id: cart.id, cart_detail_id: nil }
        end
        it_behaves_like "flash danger message", "cart_detail.is_nil"
        it_behaves_like "redirect to path", "root_path"
      end

      context "when cart detail is valid" do
        it "return cart detail" do
          delete :destroy, params: { id: cart.id, cart_detail_id: cart_details.first.id }
          cart_detail_test = cart_details.first
          expect(assigns(:cart_detail)).to eq cart_detail_test
        end

        context "when delete cart detail" do
          it "deletess successfully" do
            expect{
              delete :destroy, params: { id: cart.id, cart_detail_id: cart_details.last.id }
            }.to change(CartDetail, :count).by(-1)
          end
          before do
            delete :destroy, params: { id: cart.id, cart_detail_id: cart_details.first.id }
          end
          it_behaves_like "flash success message", "cart.delete_success"
          it_behaves_like "redirect to path", "cart_path"
        end
      end
    end

    context "when user is not signed in" do
      include_context "signed out user"
      it "redirects to sign-in page" do
        delete :destroy, params: { id: cart.id, cart_detail_id: 1 }
        expect(response).to redirect_to(new_user_session_path(locale: nil))
      end
    end
  end

  describe "POST #check_remain_and_redirect" do
    context "when user is signed in" do
      include_context "signed in user"
      context "when quantity is less than or equal to remain quantity" do
        before do
          post :check_remain_and_redirect
        end
        it "checks successfully" do
          cart_details.each do |cart_detail|
            expect(cart_detail.product.remain_quantity >= cart_detail.quantity)
          end
        end
        it_behaves_like "redirect to path", "new_bill_path"
      end
      context "when quantity is greater than remain quantity" do
        before do
          allow(cart_details.first).to receive(:remain_quantity).and_return(cart_details.first.quantity - 1)
          post :check_remain_and_redirect
        end
        it_behaves_like "flash danger message", "cart.quantity_greater_than_remain"
        it "redirect to cart path" do
          expect(response).to redirect_to(cart_path(user))
        end
      end
    end

    context "when user is not signed in" do
      include_context "signed out user"
      it "redirects to sign-in page" do
        post :check_remain_and_redirect
        expect(response).to redirect_to(new_user_session_path(locale: nil))
      end
    end
  end
end
