load './stock_io.rb'

# defining the types of stock sources
CSV_STOCK_SRC = 0
JSON_STOCK_SRC = 1
WEB_STOCK_SRC = 2

# ---------------------------------------------------------------------------------

# Remark: As a consensus, the 'data stream' returned by each of the StockReaders will
#         be considered consistent for each 'stock data type'. By consistent i mean
#         that all the 'weekly stock data' will have the same format (order of title,
#         ticker, etc.) whether it comes from a .csv file, a .json file or another
#         'stock source'. The same is assumed for the 'daily stock data', the 'monthly
#         stock data', or any other future kind of 'stock data'.

class StockData

  protected
    # represents the stock reader (CsvStockReader, JsonStockReader, etc.)
    @stock_reader = nil

    # represents the 'title' of the current stock data source
    @title = nil

    # represents the 'social reason' of the current stock data source
    @social_reason = nil

    # represents the 'ticker' of the current stock data source
    @ticker = nil

    # represents the 'series' of the current stock data source
    @series = nil

    # represents the start date of the current stock data source
    @start_date = nil

    # represents the 'end date' of the current stock data source
    @end_date = nil

    # represents the 'buyers' date of the current stock data source
    @buyers = nil

    # represents the 'sellers' date of the current stock data source
    @sellers = nil

    # represents the 'facts metadata' of the current stock data source
    @facts_meta = nil

    # represents the 'facts' (the raw data) of the current stock data source
    @facts = nil

    # gets information from data stream
    def get_info_from_stream()
      # empty --> this is like an abstract class method
    end

  public
    # basic information data
    def get_title()
      return @title
    end

    def get_social_reason()
      return @social_reason
    end

    def get_ticker()
      return @ticker
    end

    def get_series()
      return @series
    end

    def get_start_date()
      return @start_date
    end

    def get_end_date()
      return @end_date
    end

    def get_facts_metadata()
      return @facts_meta
    end

    def get_facts()
      return @facts
    end

    # advanced information data
    def get_buyers()
      buyers_array = Array.new()

      # adding current buyer to all registered buyers
      for fact in @facts do
        buyers_array << fact[2]
      end

      # returning the response
      return Set.new(buyers_array)
    end

    def get_sellers()
      sellers_array = Array.new()

      # adding current seller to all registered sellers
      for fact in @facts do
        sellers_array << fact[3]
      end

      # returning the response
      return Set.new(sellers_array)
    end

    def get_total_sold_products()
      total_sold_products = 0

      for fact in @facts do
        total_sold_products += fact[4].to_i()
      end

      return total_sold_products
    end

    def initialize(stock_source, stock_source_type)
      begin
        # case of a .csv stock source
        if stock_source_type == CSV_STOCK_SRC
          @stock_reader = CsvStockReader.new(stock_source)

        # case of a .json stock source
        elsif stock_source_type == JSON_STOCK_SRC
          @stock_reader = JsonStockReader.new(stock_source)

        # case of a web stock source
        elsif stock_source_type == WEB_STOCK_SRC
          @stock_reader = WebStockReader.new(stock_source)
        else
          raise Exception.new('Unknown stock source type.')
        end
      rescue Exception => e
        # raising the exception again
        e.raise()
      end

      # initializing data structures
      @facts = Array.new()

      # getting information from data stream
      get_info_from_stream()
    end

end

# ---------------------------------------------------------------------------------

class DailyStockData < StockData

  def initialize(stock_source, stock_source_type)
    # just calling parent for now
    super(stock_source, stock_source_type)
  end

  def get_info_from_stream()
    # empty --> depending on the structure of a daily stock data, which i don't have yet
  end

end

# ---------------------------------------------------------------------------------

class WeeklyStockData < StockData

  # weekly stock metadata constants
  TITLE_INDEX = 0
  SOCIAL_INDEX = 2
  TICKER_INDEX = 3
  SERIES_INDEX = 4
  START_DATE_INDEX = 5
  END_DATE_INDEX = 6
  FACTS_META_INDEX = 10
  FACTS_INDEX = 11

  def initialize(stock_source, stock_source_type)
    # just calling parent for now
    super(stock_source, stock_source_type)
  end

  def get_info_from_stream()
    # setting the data stream to a local variable
    stock_data = @stock_reader.get_data_stream()

    # getting the stock data 'title'
    @title = stock_data[TITLE_INDEX][0] # the first column

    # getting the stock data 'social reason'
    social_reason_data = stock_data[SOCIAL_INDEX][0]
    @social_reason = social_reason_data.split(':')[1].strip() # the right part of the first column

    # getting the stock data 'ticker'
    ticker_data = stock_data[TICKER_INDEX][0]
    @ticker = ticker_data.split(':')[1].strip() # the right part of the first column

    # getting the stock data 'series'
    series_data = stock_data[SERIES_INDEX][0]
    @series = series_data.split(':')[1].strip() # the right part of the first column

    # getting the stock data 'start date'
    start_date_data = stock_data[START_DATE_INDEX][0]
    start_splitted = start_date_data.split(':')[1].split('/') # splitting by ':' and '/'
    month = start_splitted[0].to_i()
    day = start_splitted[1].to_i()
    year = start_splitted[2].to_i()
    @start_date = Date.new(year, month, day)

    # getting the stock data 'end date'
    end_date_data =  stock_data[END_DATE_INDEX][0]
    end_splitted = end_date_data.split(':')[1].split('/') # splitting by ':' and '/'
    month = end_splitted[0].to_i()
    day = end_splitted[1].to_i()
    year = end_splitted[2].to_i()
    @end_date = Date.new(year, month, day)

    # getting the 'facts metadata'
    @facts_meta = stock_data[FACTS_META_INDEX]

    # getting 'facts'
    ub = stock_data.count() - 1

    for i in FACTS_INDEX..ub
      # storing raw facts information
      @facts << stock_data[i]
    end
  end

end

# ---------------------------------------------------------------------------------

class MonthlyStockData < StockData

  def initialize(stock_source, stock_source_type)
    # just calling parent for now
    super(stock_source, stock_source_type)
  end

  def get_info_from_stream()
    # empty --> depending on the structure of a daily stock data, which i don't have yet
  end

end

# ---------------------------------------------------------------------------------
