require "rails_helper"

RSpec.describe Bill, type: :model do
  describe "validations" do
    context "when valid attributes are provide" do
      it "is valid with correct phone_number format" do
        should allow_value("0901234567").for(:phone_number)
      end

      it "cancellation reason can be nil" do
        should_not validate_presence_of(:cancellation_reason)
      end

      it "is valid with a total value" do
        should validate_presence_of(:total)
      end

      it "is valid with total_after_discount" do
        should validate_presence_of(:total_after_discount)
      end
    end

    context "when invalid attributes are provided" do
      it "is invalid if phone_number is missing" do
        should_not allow_value(nil).for(:phone_number)
      end

      it "is invalid with incorrect phone_number format" do
        should_not allow_value("12345").for(:phone_number)
      end

      it "is invalid without a total value" do
        should validate_presence_of(:total)
      end

      it "is invalid without total_after_discount" do
        should validate_presence_of(:total_after_discount)
      end
    end
  end

  describe "enums" do
    context "when enums are defined" do
      it "defines status enum correctly" do
        should define_enum_for(:status).with_values(wait_for_pay: 0, wait_for_prepare: 1, wait_for_delivery: 2, completed: 3, cancelled: 4)
      end

      it "defines cancellation_reason enum correctly" do
        should define_enum_for(:cancellation_reason).with_values(out_of_stock: 0, wrong_quantity: 1, wrong_product: 2)
      end
    end

    context "when enums are not defined" do
      it "raises an error if status enum is not defined" do
        should_not define_enum_for(:status).with_values(pending: 5, refunded: 6)
      end

      it "raises an error if cancellation_reason enum is not defined" do
        should_not define_enum_for(:cancellation_reason).with_values(dont_like: 3, sad: 4)
      end
    end
  end

  describe "associations" do
    context "when associations are correct" do
      it "belongs to user" do
        should belong_to(:user)
      end

      it "belongs to voucher optionally" do
        should belong_to(:voucher).optional
      end

      it "has many bill_details" do
        should have_many(:bill_details).dependent(:destroy)
      end

      it "has many products through bill_details" do
        should have_many(:products).through(:bill_details)
      end

      it "has one address" do
        should have_one(:address).dependent(:destroy)
      end
    end
  end

  describe "scopes" do
    let!(:bill_1) { FactoryBot.create(:bill, status: :completed, created_at: Time.zone.now - 1.day) }
    let!(:bill_2) { FactoryBot.create(:bill, status: :wait_for_delivery, created_at: Time.zone.now - 2.days) }
    let!(:bill_3) { FactoryBot.create(:bill, status: :completed, created_at: 2.months.ago) }

    context "when querying with valid date range" do
      context "newest" do
        it "returns bills ordered by created_at in descending order" do
          expect(Bill.newest).to eq([bill_1, bill_2, bill_3])
        end
      end

      context "status_bills" do
        it "returns a count of bills by status within a date range" do
          result = Bill.status_bills(bill_2.created_at, bill_1.created_at)
          expect(result).to eq({ "completed" => 1, "wait_for_delivery" => 1 })
        end
      end

      context "incomes" do
        it "returns total income grouped by day within a date range" do
          result = Bill.incomes(bill_2.created_at, bill_1.created_at)
          expect(result[bill_1.created_at.to_date]).to eq(bill_1.total_after_discount)
        end
      end

      context "monthly_incomes_report" do
        it "returns the correct sum of completed bills within the date range" do
          result = Bill.monthly_incomes_report(1.months.ago, Time.zone.now)
          expected_result = bill_1.total_after_discount
          expect(result).to eq(expected_result)
        end
      end
    end

    context "when querying with invalid or no matching date range" do
      context "newest" do
        it "does not return bills in ascending order" do
          expect(Bill.newest).not_to eq([bill_2, bill_1])
        end
      end

      context "status_bills" do
        it "returns an empty hash if no bills match the date range" do
          result = Bill.status_bills(Time.zone.now + 1.day, Time.zone.now + 2.days)
          expect(result).not_to eq({ "completed" => 1, "wait_for_delivery" => 1 })
        end
      end

      context "incomes" do
        it "returns empty hash if no incomes are available" do
          result = Bill.incomes(Time.zone.now + 1.day, Time.zone.now + 2.days)
          expect(result[bill_1.created_at.to_date]).not_to eq(bill_1.total_after_discount)
        end
      end
      context "monthly_incomes_report" do
        it "returns the wrong sum of completed bills within the date range" do
          result = Bill.monthly_incomes_report(1.months.ago, Time.zone.now)
          expected_result = bill_1.total_after_discount + bill_2.total_after_discount + bill_3.total_after_discount
          expect(result).not_to eq(expected_result)
        end
      end
    end
  end

  describe "callbacks" do
    let(:bill) { FactoryBot.build(:bill) }
    context "when saving the bill" do
      it "sets the expired_at 1 day before saving" do
        expect { bill.save }.to change(bill, :expired_at).to(be_within(1.second).of(24.hours.from_now))
      end

      it "does not incorrectly set the expired_at" do
        expect(bill.expired_at).not_to be_within(1.second).of(23.hours.from_now)
      end

      it "calculates the total_after_discount before saving" do
        voucher = FactoryBot.create :voucher, discount: 0.1
        bill = FactoryBot.build :bill, voucher: voucher
        expect_value = bill.total - bill.total * voucher.discount
        expect(bill.total_after_discount).to eq(expect_value.to_i)
      end
    end
    context "when the bill fails to save" do
      before do
        allow(bill).to receive(:save).and_return(false)
      end

      it "does not change expired_at" do
        expect { bill.save }.not_to change(bill, :expired_at)
      end

      it "does not calculate the total_after_discount" do
        expect { bill.save }.not_to change(bill, :total_after_discount)
      end
    end
  end

  describe "#calculate_subtotal" do
    context "when bill details are provided" do
      prod1 = FactoryBot.create :product, price: 1000
      prod2 = FactoryBot.create :product, price: 5000
      bill_details =[
        FactoryBot.build(:bill_detail, product: prod1, quantity: 2),
        FactoryBot.build(:bill_detail, product: prod2, quantity: 10),
      ]
      bill = FactoryBot.create :bill, bill_details: bill_details
      total = prod1.price * 2 + prod2.price * 10
      it "calculates the subtotal based on bill details" do
        expect(bill.calculate_subtotal).to eq total
      end
      it "wrong subtotal based on bill details" do
        expect(bill.calculate_subtotal).not_to eq total + 1
      end
    end
    context "when no bill details are provided" do
      let(:bill) { FactoryBot.create :bill, bill_details: [] }

      it "calculates the subtotal as 0" do
        expect(bill.calculate_subtotal).to eq 0
      end

      it "does not incorrectly calculate the subtotal" do
        expect(bill.calculate_subtotal).not_to eq 1
      end
    end
  end
end
