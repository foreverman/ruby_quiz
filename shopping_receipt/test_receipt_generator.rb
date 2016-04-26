require 'minitest/autorun'
require_relative "receipt_generator"

class TestReceiptGenerator < Minitest::Test
  def test_generate_receipt_without_any_promotional_offer
    grocery_list = [
      {name: '可口可乐', quantity: 3, price: 3, unit: '瓶'},
      {name: '羽毛球', quantity: 5, price: 1, unit: '个'},
      {name: '苹果', quantity: 2, price: 5.5, unit: '斤'}
    ]

    receipt = ReceiptGenerator.new.generate(grocery_list)
    expected = <<-RECEIPT
***<没钱赚商店>购物清单***
名称: 可口可乐, 数量: 3瓶, 单价: 3.00(元), 小计: 9.00(元)
名称: 羽毛球, 数量: 5个, 单价: 1.00(元), 小计: 5.00(元)
名称: 苹果, 数量: 2斤, 单价: 5.50(元), 小计: 11.00(元)
----------------------
总计: 25.00(元)
**********************
    RECEIPT

    assert_equal expected.strip, receipt

  end

  def test_generate_receipt_with_buy_two_one_free_promotional_offer
    grocery_list = [
      {name: '可口可乐', quantity: 3, price: 3, unit: '瓶', promotional_offer: 'buy_two_one_free'},
      {name: '羽毛球', quantity: 5, price: 1, unit: '个', promotional_offer: 'buy_two_one_free'},
      {name: '苹果', quantity: 2, price: 5.5, unit: '斤'}
    ]

    receipt = ReceiptGenerator.new.generate(grocery_list)
    expected = <<-RECEIPT
***<没钱赚商店>购物清单***
名称: 可口可乐, 数量: 3瓶, 单价: 3.00(元), 小计: 6.00(元)
名称: 羽毛球, 数量: 5个, 单价: 1.00(元), 小计: 4.00(元)
名称: 苹果, 数量: 2斤, 单价: 5.50(元), 小计: 11.00(元)
----------------------
买二赠一商品:
名称: 可口可乐, 数量: 1瓶
名称: 羽毛球, 数量: 1个
----------------------
总计: 21.00(元)
节省: 4.00(元)
**********************
    RECEIPT

    assert_equal expected.strip, receipt
  end

  def test_generate_receipt_with_95discount_promotional_offer
    grocery_list = [
      {name: '可口可乐', quantity: 3, price: 3, unit: '瓶'},
      {name: '羽毛球', quantity: 5, price: 1, unit: '个'},
      {name: '苹果', quantity: 2, price: 5.5, unit: '斤', promotional_offer: '95discount'}
    ]

    receipt = ReceiptGenerator.new.generate(grocery_list)
    expected = <<-RECEIPT
***<没钱赚商店>购物清单***
名称: 可口可乐, 数量: 3瓶, 单价: 3.00(元), 小计: 9.00(元)
名称: 羽毛球, 数量: 5个, 单价: 1.00(元), 小计: 5.00(元)
名称: 苹果, 数量: 2斤, 单价: 5.50(元), 小计: 10.45(元), 节省0.55(元)
----------------------
总计: 24.45(元)
节省: 0.55(元)
**********************
    RECEIPT

    assert_equal expected.strip, receipt
  end

  def test_generate_receipt_with_both_95discount_and_buy_two_one_free
    grocery_list = [
      {name: '可口可乐', quantity: 3, price: 3, unit: '瓶', promotional_offer: 'buy_two_one_free'},
      {name: '羽毛球', quantity: 6, price: 1, unit: '个', promotional_offer: 'buy_two_one_free'},
      {name: '苹果', quantity: 2, price: 5.5, unit: '斤', promotional_offer: '95discount'}
    ]

    receipt = ReceiptGenerator.new.generate(grocery_list)
    expected = <<-RECEIPT
***<没钱赚商店>购物清单***
名称: 可口可乐, 数量: 3瓶, 单价: 3.00(元), 小计: 6.00(元)
名称: 羽毛球, 数量: 6个, 单价: 1.00(元), 小计: 4.00(元)
名称: 苹果, 数量: 2斤, 单价: 5.50(元), 小计: 10.45(元), 节省0.55(元)
----------------------
买二赠一商品:
名称: 可口可乐, 数量: 1瓶
名称: 羽毛球, 数量: 2个
----------------------
总计: 20.45(元)
节省: 5.55(元)
**********************
    RECEIPT

    assert_equal expected.strip, receipt
  end
end
