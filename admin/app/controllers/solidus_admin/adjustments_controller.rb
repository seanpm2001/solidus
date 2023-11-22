# frozen_string_literal: true

class SolidusAdmin::AdjustmentsController < SolidusAdmin::BaseController
  before_action :load_order

  def index
    @adjustments = @order
      .all_adjustments
      .eligible
      .order("adjustable_type ASC, created_at ASC")
      .ransack(params[:q])
      .result

    set_page_and_extract_portion_from(@adjustments)

    respond_to do |format|
      format.html do
        render component('orders/show/adjustments/index').new(
          order: @order,
          adjustments: @adjustments,
        )
      end
    end
  end

  def lock
    @adjustments = @order.all_adjustments.not_finalized.where(id: params[:id])
    @adjustments.each(&:finalize!)
    flash[:success] = t('.success')

    redirect_to order_adjustments_path(@order)
  end

  def unlock
    @adjustments = @order.all_adjustments.finalized.where(id: params[:id])
    @adjustments.each(&:unfinalize!)
    flash[:success] = t('.success')

    redirect_to order_adjustments_path(@order)
  end

  def destroy
    @adjustment = @order.all_adjustments.find(params[:id])
    @adjustment.destroy
    flash[:success] = t('.success')

    redirect_to order_adjustments_path(@order)
  end

  private

  def load_order
    @order = Spree::Order.find_by!(number: params[:order_id])
  end
end
