# frozen_string_literal: true

class SolidusAdmin::Orders::Show::Adjustments::Index::Component < SolidusAdmin::BaseComponent
  include SolidusAdmin::Layout::PageHelpers
  NBSP = "&nbsp;".html_safe

  def initialize(order:, adjustments:)
    @order = order
    @adjustments = adjustments
  end

  def form_id
    @form_id ||= "#{stimulus_id}--form-#{@order.id}"
  end

  def icon_thumbnail(name)
    render component("ui/thumbnail").new(src: svg_data_uri(icon_tag(name)))
  end

  def svg_data_uri(data)
    "data:image/svg+xml;base64,#{Base64.strict_encode64(data)}"
  end

  def figcaption_for_source(adjustment)
    return thumbnail_caption(adjustment.label, nil) unless adjustment.source_type

    # ["Spree::PromotionAction", nil, "Spree::UnitCancel", "Spree::TaxRate"]
    record = adjustment.source
    record_class = adjustment.source_type&.constantize
    model_name = record_class.model_name.human

    case record || record_class
    when Spree::TaxRate
      detail = link_to("#{model_name}: #{record.zone&.name || t('spree.all_zones')}", spree.edit_admin_tax_rate_path(adjustment.source_id), class: "body-link")
    when Spree::PromotionAction
      detail = link_to("#{model_name}: #{record.promotion.name}", spree.edit_admin_promotion_path(adjustment.source_id), class: "body-link")
    else
      detail = "#{model_name}: #{record.display_amount}" if record.respond_to?(:display_amount)
    end

    thumbnail_caption(adjustment.label, detail)
  end

  def figcaption_for_adjustable(adjustment)
    # ["Spree::LineItem", "Spree::Order", "Spree::Shipment"]
    record = adjustment.adjustable
    record_class = adjustment.adjustable_type&.constantize

    case record || record_class
    when Spree::LineItem
      variant = record.variant
      options_text = variant.options_text.presence

      description = options_text || variant.sku
      detail = link_to(variant.product.name, solidus_admin.product_path(record.variant.product), class: "body-link")
    when Spree::Order
      description = "#{Spree::Order.model_name.human} ##{record.number}"
      detail = record.display_total
    when Spree::Shipment
       description = "#{t('spree.shipment')} ##{record.number}"
       detail = link_to(record.shipping_method.name, spree.edit_admin_shipping_method_path(record.shipping_method), class: "body-link")
    when nil
      # noop
    else
      name_method = [:display_name, :name, :number].find { record.respond_to? _1 } if record
      price_method = [:display_amount, :display_total, :display_cost].find { record.respond_to? _1 } if record

      description = record_class.model_name.human
      description = "#{description} - #{record.public_send(name_method)}" if name_method

      # attempt creating a link
      url_options = [:admin, record, :edit, { only_path: true }]
      url = begin; spree.url_for(url_options); rescue NoMethodError => e; logger.error(e.to_s); nil end

      description = link_to(description, url, class: "body-link") if url
      detail = record.public_send(price_method) if price_method
    end

    thumbnail_caption(description, detail)
  end

  def thumbnail_caption(first_line, second_line)
    tag.figcaption(safe_join([
      tag.div(first_line || NBSP, class: 'text-black body-small whitespace-nowrap text-ellipsis overflow-hidden'),
      tag.div(second_line || NBSP, class: 'text-gray-500 body-small whitespace-nowrap text-ellipsis overflow-hidden')
    ]), class: "flex flex-col gap-0 max-w-[15rem]")
  end
end
