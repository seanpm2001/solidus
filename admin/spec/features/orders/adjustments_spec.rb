# frozen_string_literal: true

require 'spec_helper'

describe "Order", :js, type: :feature do
  before { sign_in create(:admin_user, email: 'admin@example.com') }

  it "allows detaching a customer from an order" do
    order = create(:order, number: "R123456789", user: create(:user))
    Spree::Adjustment.insert_all([
      {
        order_id: order.id,
        adjustable_id: order.id,
        adjustable_type: "Spree::Order",
        amount: 10,
        label: "Test Adjustment",
        eligible: true,
        finalized: false,
        created_at: Time.current,
        updated_at: Time.current,
        included: false,
        source_type: "Spree::Order",
        source_id: order.id,
        promotion_code_id: nil,
      },
    ])
    visit "/admin/orders/R123456789"

    click_on "Adjustments"
    expect(page).to have_content("Test Adjustment")

    expect(page).to be_axe_clean
  end
end
