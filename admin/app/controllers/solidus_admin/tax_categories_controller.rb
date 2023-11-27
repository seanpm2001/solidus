# frozen_string_literal: true

module SolidusAdmin
  class TaxCategoriesController < SolidusAdmin::BaseController
    include SolidusAdmin::ControllerHelpers::Search

    def index
      tax_categories = apply_search_to(
        Spree::TaxCategory.order(created_at: :desc, id: :desc),
        param: :q,
      )

      set_page_and_extract_portion_from(tax_categories)

      respond_to do |format|
        format.html { render component('tax_categories/index').new(page: @page) }
      end
    end

    def destroy
      @tax_categories = Spree::TaxCategory.where(id: params[:id])

      Spree::TaxCategory.transaction { @tax_categories.destroy_all }

      flash[:notice] = t('.success')
      redirect_back_or_to tax_categories_path, status: :see_other
    end

    private

    def load_tax_category
      @tax_category = Spree::TaxCategory.find_by!(number: params[:id])
      authorize! action_name, @tax_category
    end

    def tax_category_params
      params.require(:tax_category).permit(:tax_category_id, permitted_tax_category_attributes)
    end

    # def authorization_subject
    #   Spree::TaxCategory
    # end
  end
end
