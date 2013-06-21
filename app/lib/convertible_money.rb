class ConvertibleMoney

  ROUND_PRECISION = 2

  attr_accessor :currency, :amount, :conversion_rate, :conversion_currency

  def initialize(currency, amount, options={})
    self.amount = amount || BigDecimal('0.00')
    self.currency = currency
    self.conversion_rate = (options && options[:conversion_rate]) || BigDecimal('1')
    self.conversion_currency = (options && options[:conversion_currency]) || currency
  end

  def to_s
    #retains backword compatibility with just printing a BigDecimal
    amount.to_s
  end

  def conversion_amount
    BigDecimal(amount * conversion_rate).round(ROUND_PRECISION)
  end


  def has_conversion?
    return !(self.conversion_currency == self.currency)
  end

  #delegate all arithmetic operations
  def respond_to?(method)
    if super
      true
    else
      @amount.respond_to?(method)
    end
  end

  def method_missing(method, *args, &block)
    if @amount.respond_to?(method)
      @amount.send(method, *args, &block)
    else
      raise NoMethodError
    end
  end


end
