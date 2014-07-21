load 'stock_data.rb'

# building a 'weekly stock data' from the 'Azteca BAS.csv'
azteca_stocks = WeeklyStockData.new('./stock-datasources/Azteca BAS.csv', CSV_STOCK_SRC)

puts('--------------------------------------------------------------------------------')

puts('Total sold products:')
puts(azteca_stocks.get_total_sold_products())

puts('--------------------------------------------------------------------------------')

puts('List of buyers:')
buyers_string = ''
azteca_stocks.get_buyers().each { |item| buyers_string += "(#{item})" }
puts(buyers_string)

puts('--------------------------------------------------------------------------------')

puts('List of sellers:')
sellers_string = ''
azteca_stocks.get_sellers().each { |item| sellers_string += "(#{item})" }
puts(sellers_string)

puts('--------------------------------------------------------------------------------')