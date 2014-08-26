class VendingMachine
  attr_reader :sale_amount

  def initialize
    @stocks = StockList.new
    @total_inserted_value = 0
    @sale_amount = 0
  end

  def stock_info
    @stocks.info
  end

  def total
    @total_inserted_value
  end

  def purchasable_drink_names
    @stocks.purchasable_drinks_with(@total_inserted_value).map(&:name)
  end

  def purchasable?(drink_name)
    @stocks.purchasable?(drink_name, @total_inserted_value)
  end

  def store(drink, amount = 1)
    @stocks.store(drink, amount)
  end

  AVAILABLE_VALUES = [10, 50, 100]

  def insert(value)
    return value unless AVAILABLE_VALUES.include?(value)
    @total_inserted_value += value
    nil
  end

  def refund
    retval = @total_inserted_value
    @total_inserted_value = 0
    retval
  end

  def purchase(drink_name)
    drink = @stocks.purchase(drink_name, @total_inserted_value)
    return nil unless drink
    @sale_amount += drink.price
    change = @total_inserted_value - drink.price
    @total_inserted_value = 0
    [drink, change]
  end

  class StockList

    def initialize
      @stocks = []
    end

    def store(drink, amount)
      stock = stock_of(drink.name)
      if stock
        stock.store(amount)
      else
        stock = Stock.new(drink, amount)
        @stocks << stock
      end
    end

    def purchase(drink_name, total_inserted_value)
      return nil unless purchasable?(drink_name, total_inserted_value)
      stock = stock_of(drink_name)
      stock.purchase
      stock.drink
    end

    def stock_of(drink_name)
      @stocks.find { |stock| stock.drink.name == drink_name }
    end

    def purchasable_drinks_with(total_inserted_value)
      @stocks.select { |stock| stock.purchasable?(total_inserted_value) }.map(&:drink)
    end

    def purchasable?(drink_name, total_inserted_value)
      stock = stock_of(drink_name)
      stock && stock.purchasable?(total_inserted_value)
    end

    def info
      @stocks.inject({}) { |h, stock| h[stock.drink.name] = {price: stock.drink.price, stock: stock.amount}; h }
    end
  end

  class Stock
    attr_reader :drink, :amount

    def initialize(drink, amount)
      @drink = drink
      @amount = amount
    end

    def store(amount)
      @amount += amount
    end

    def purchase
      @amount -= 1 if @amount > 0
    end

    def purchasable?(total_inserted_value)
      amount > 0 && drink.price <= total_inserted_value
    end
  end
end


class Drink
  attr_reader :name, :price

  def initialize(name, price)
    @name  = name
    @price = price
  end

  def self.cola
    @@cola ||= new(:cola, 120)
  end

  def self.water
    @@water ||= new(:water, 100)
  end

  def self.redbull
    @@redbull ||= new(:redbull, 200)
  end
end
