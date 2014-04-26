class Calculator
  constructor: (args) ->
  # キャッシュフロー計算
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
    # チップ購入費用
    @chip_expenses = args["chip_expenses"]
    # 賃借料
    @rental_expenses = args["rental_expenses"]
    # その他販管費
    @other_expenses = args["other_expenses"]
    # 支払利息
    @interest = args["interest"]
    # 借入金返済費用
    @back_debt = args["back_debt"]
    # 特別損失
    @extra_loss = args["extra_loss"]
    # 固定資産購入費用
    @asset_payment = args["asset_payment"]

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


  # 総収入計算
  totalSales: ->
    total_sales = @sales + @debt + @investment_sales + @asset_sales
  # 総支出計算
  totalExpenditures: ->
    total_expenditures = @stock_cost + @fixedCost + @back_debt +@extra_loss +@asset_payment

  # 手持ち現金計算
  currentCache: ->
    current_cache = @initial_cache + @totalSales - @totalExpenditures
    return cache

  # 棚卸計算（要：商品換算額 　デフォルト値1.9）
  inventory: (price_product = 1.9)->
    inventory = price_product * @number_products

# PL計算
  # 売上原価（変動費）
  salesCost: ->
    sales_cost = @stock_cost + @initial_inventory  - @inventory
  # 固定費計算
  fixedCost: ->
    fixed_cost = @labor_expenses + @chip_expenses + @rental_expenses +@interest
  # 売上総利益（粗利）
  margin :->
    margin = @sales - @salesCost
  # 経常利益（ボード版では出なかった）
  ordinaryProfit: ->
    ordinary_profit = @margin - @fixedCost
  # 純利益計算
  netProfit: ->
    net_profit = @ordinaryProfit - @back_debt - @extra_loss - @asset_payment
    return net_profit

  # 法人税額計算(要：税率 デフォルト値0.4)
  corporationTax: (tax_rate = 0.4)->
    if ( @initial_surplus + @ordinaryProfit < 0 )
      corporation_tax = 0
    else
      corporation_tax = net_income * tax_rate
    # return corporation_tax
  # 剰余金(次期繰越)
  surplus: ->
    surplus = @initial_surplus + @netProfit - @corporation_tax
  # 借入金残高(次期残高)
  currentDebt: ->
    current_debt = @initial_debt + @debt - @back_debt

# BS計算
  # 流動資産
  liquidAssets: ->
    liquid_assets = @currentCache + @inventory
  # 資産合計
  totalAssets: ->
    total_assets = @liquidAssets
  # 負債
  totalDebt: ->
    total_debt = @currentDebt + @corporationTax
  # 資本金
  currentCapital: ->
    current_capital = @initial_capital + @investment_sales
  # 純資産
  totalEquity: ->
    total_equity = @currentCapital + @surplus
    return total_equity

#calc = new Calculator
#calc.sales += 100
#calc.loan += 10
