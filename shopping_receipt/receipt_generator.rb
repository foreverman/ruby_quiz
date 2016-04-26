require 'ostruct'

class ReceiptGenerator
  def generate(grocery_list)
    grocery_list = GroceryList.new(grocery_list)
    result = ""
    output_header(result)
    output_details(result, grocery_list)
    output_separator(result)
    output_buy_two_one_free_summary(result, grocery_list)
    output_total_summary(result, grocery_list)
    output_footer(result)
    result
  end

  private
  def output_buy_two_one_free_summary(result, grocery_list)
    if grocery_list.buy_two_one_free_applied?
      result << "买二赠一商品:"
      result << "\n"
      grocery_list.items_with_buy_two_one_free.each do |item|
        result << "名称: #{item.name}, 数量: #{item.free_quantity}#{item.unit}"
        result << "\n"
      end
      output_separator(result)
    end
  end

  def output_header(result)
    result << "***<没钱赚商店>购物清单***"
    result << "\n"
  end

  def output_details(result, grocery_list)
    grocery_list.grocery_items.each do |item|
      result << receipt_item(item)
      result << "\n"
    end
  end
  
  def receipt_item(item)
    result = "名称: #{item.name}, 数量: #{item.quantity}#{item.unit}, 单价: #{number_to_currency(item.price)}(元), 小计: #{number_to_currency(item.subtotal)}(元)"
    if item.promotional_offer.instance_of? Discount
      result << ", "
      result << "节省#{number_to_currency(item.savings)}(元)"
    end
    result
  end

  def output_separator(result)
    result << "----------------------"
    result << "\n"
  end

  def output_total_summary(result, grocery_list)
    result << "总计: #{number_to_currency(grocery_list.total_paid)}(元)"
    if (total_savings = grocery_list.total_savings) > 0
      result << "\n"
      result << "节省: #{number_to_currency(total_savings)}(元)"
    end
    result << "\n"
  end

  def output_footer(result)
    result << "**********************"
  end

  def number_to_currency(number)
    sprintf("%.2f", number)
  end
end

class GroceryList
  def initialize(grocery_list)
    @items = grocery_list.map do |item| 
      attributes = item.reject{|key, value| key == :promotional_offer}
      if promotional_offer = item[:promotional_offer]
        if promotional_offer == 'buy_two_one_free'
          attributes[:promotional_offer] = BuyTwoOneFree.new
        elsif promotional_offer == '95discount'
          attributes[:promotional_offer] = Discount.new
        end
      end
      GroceryItem.new(attributes)
    end
  end

  def total_paid
    @items.inject(0) {|total, item| total += item.subtotal} 
  end

  def total_savings
    @items.inject(0) {|total, item| total += item.savings} 
  end

  def grocery_items
    @items
  end

  def buy_two_one_free_applied?
    @items.any? {|item| item.promotional_offer.instance_of? BuyTwoOneFree}
  end

  def items_with_buy_two_one_free
    items_applied = @items.select {|item| item.promotional_offer.instance_of? BuyTwoOneFree}
    items_applied.map do |item| 
      OpenStruct.new(
        name: item.name, unit: item.unit, 
        free_quantity: item.promotional_offer.calculate_free_quantity(item)
      )
    end
  end
end

class GroceryItem
  attr_reader :name, :price, :quantity, :unit, :promotional_offer

  def initialize(name:, price:, quantity:, unit:, promotional_offer: nil)
    @name = name
    @price = price
    @quantity = quantity
    @unit = unit
    @promotional_offer = promotional_offer
  end

  def subtotal
    if promotional_offer
      promotional_offer.calculate_total_price(self)
    else
      price * quantity
    end
  end

  def savings
    price * quantity - subtotal
  end
end

class BuyTwoOneFree
  def calculate_total_price(item)
    triple_count, left = item.quantity.divmod 3
    (triple_count * 2 + left) * item.price
  end

  def calculate_free_quantity(item)
    item.quantity / 3
  end
end

class Discount
  def calculate_total_price(item)
    item.quantity * item.price * 0.95
  end
end
