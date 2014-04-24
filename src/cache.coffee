class Calculator
  constructor: (args) ->

    # 売り上げ
    @sales = args["sales"]
    # 借入金
    @debt = args["debt"]
    # 出資収入
    @investment_sales = args["investment_sales"]
    # 資産売却
    @asset_sales = args["asset_sales"]

    # 商品仕入(原価)
    @stock_cost = args["stock_cost"]
    # 人件費
    @labor_expenses = args["labor_expenses"]
    # チップ購入
    @chip_expenses = args["chip_expenses"]
    # 賃借料
    @rental_expenses = args["rental_expenses"]
    # その他販管費
    @other_expenses = args["other_expenses"]
    # 支払利息
    @interest = args["interest"]
    # 借入金返済
    @back_debt = args["back_debt"]
    # 特別損失
    @extra_loss = args["extra_loss"]
    # 固定資産購入
    @asset_payment = args["asset_payment"]


  currentCache: ->
    cache = @init_cache + @income
    # return cache

  fukidomethod: (number_of_product)->
    unit_price = 100
    @sell_price = number_of_product * unit_price
    return @sell_price

#calc = new Calculator
#calc.sales += 100
#calc.loan += 10

#calc.totalSales()
#=> 売上高