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

    # 総収入
    total_sales = @sales + @debt + @investment_sales + @asset_sales


    # 商品仕入(原価)
    @stock_cost = args["stock_cost"]

    # 人件費
    @labor_expenses = args["labor_expenses"]
    # チップ購入費用
    @chip_expenses = args["chip_expenses"]
    # 賃借料
    @rental_expenses = args["rental_expenses"]
    # その他販管費
    @other_expenses = args["other_expenses"]
    # 支払利息
    @interest = args["interest"]

    # 固定費
    fixed_cost = @labor_expenses + @chip_expenses + @rental_expenses +@interest

    # 借入金返済費用
    @back_debt = args["back_debt"]
    # 特別損失
    @extra_loss = args["extra_loss"]
    # 固定資産購入費用
    @asset_payment = args["asset_payment"]

    # 総支出
    total_expenditures = @stock_cost + fixed_cost + @back_debt +@extra_loss +@asset_payment


    # 商品個数
    @number_products = args["number_product"]
    # 社員数
    @number_employees = args["number_employees"]


    # ゲーム開始時の手持ち現金？
    @initial_number_products = args["initial_number_products"]
    # ゲーム開始時の手持ち現金？
    @initial_number_employees = args["initial_number_employees"]    
    # ゲーム開始時の手持ち現金？
    @initial_cache = args["initial_cache"]
    # 前期（ゲーム開始時）棚卸
    @initial_inventory = args["initial_inventory"]
    # 前期（ゲーム開始時）剰余金
    @initial_surplus = args["initial_surplus"]
    # 前期（ゲーム開始時）資産
    @initial_capital = args["initial_capital"]
    # 前期（ゲーム開始時）借入金
    @initial_debt = args["initial_debt"]

    # # 手持ち現金？？
    # @cache = @initial_cache + total_sales - total_expenditures

    # 棚卸(商品価格1.9,固定)
    inventory = 1.9 * @number_products
    # 売上原価（変動費）
    sales_cost = @stock_cost + @initial_inventory  - inventory
    # 売上総利益（粗利）
    margin = @sales - sales_cost
    # 経常利益（ボード版では出なかった）
    ordinary_profit = margin - fixed_cost
    # # 純利益
    # @net_profit = @sales - sales_cost - fixed_cost - @back_debt - @extra_loss - @asset_payment

    # 法人税
    corporation_tax = 

    # 前期剰余金
    surplus = @initial_surplus + @net_profit - @corporation_tax

    # 流動資産
    liquid_assets = @cache + @inventory
    # 資産合計
    total_assets = @liquid_assets
    # 負債
    total_debt = @debt - @back_debt + @corporation_tax
    # 純資産
    @total_equity = @capital + @surplus


  # 手持ち現金計算 (要:ゲーム開始時の手持ち現金)
  currentCache: (initial_cache)->
    cache = initial_cache + total_sales - total_expenditures
    # return cache

  # 棚卸計算（要：商品換算額 　デフォルト値1.9）
  inventory: (price_product = 1.9)->
    @inventory = price_product * @number_products

  # 純利益計算
  netProfit: ->
    net_profit = @sales - sales_cost - fixed_cost - @back_debt - @extra_loss - @asset_payment

  # 法人税額計算(要：税率 デフォルト値0.4)
  corporation_tax: (tax_rate = 0.4)->
    if ( @initial_surplus + ordinary_profit < 0 )
      corporation_tax = 0
    else
      corporation_tax = net_income * tax_rate


  fukidomethod: (number_of_product)->
    unit_price = 100
    @sell_price = number_of_product * unit_price
    return @sell_price

#calc = new Calculator
#calc.sales += 100
#calc.loan += 10
