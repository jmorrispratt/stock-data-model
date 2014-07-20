require 'csv'
require 'set'

# ---------------------------------------------------------------------------------

# represents an abstract Stock Reader
class StockReader

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

  # represents the 'facts' (the raw data) of the current stock data source
  @facts = nil


  # StockReader initializer
  def initialize(stock_source)
    # checking if stock source is valid
    if stock_source.class != String
      raise Exception.new('The stock source must be a string.')
    end

    # storing the stock source value
    @stock_source = stock_source

    # initializing the more complex data structures
    @facts = Array.new()

    # use threads here
    # reading information from source
    read_from_source(@stock_source)
  end

  public
    def get_title()
      # empty --> this is like an abstract class method
    end

    def get_social_reason()
      # empty --> this is like an abstract class method
    end

    def get_ticker()
      # empty --> this is like an abstract class method
    end

    def get_series()
      # empty --> this is like an abstract class method
    end

    def get_start_date()
      # empty --> this is like an abstract class method
    end

    def get_end_date()
      # empty --> this is like an abstract class method
    end

    def get_buyers()
      return @buyers.to_a()
    end

    def get_sellers()
      return @sellers.to_a()
    end

  protected
    def read_from_source(stock_source)
      # empty --> this is like an abstract class method
    end

end

# ---------------------------------------------------------------------------------

# represents a Csv Stock Reader
class CsvStockReader < StockReader

  @@csv_suffix = '.csv'


  # CsvStockReader initializer
  def initialize(stock_source)
    # checking wether the stock source is a .csv file
    if csv_stock_source_is_invalid?(stock_source)
      raise Exception.new('The stock source must be a .csv file.')
    end

    # building parent
    super(stock_source)
  end

  # overriden methods
  def read_from_source(stock_source)
    read_from_csv(stock_source)
  end

  private
    def csv_stock_source_is_invalid?(csv_stock_source)
      return !csv_stock_source.end_with?(@@csv_suffix)
    end

    def read_from_csv(csv_file_path)
      # the structure of the .csv file is considered fixed by now (based on Azteca BAS.csv)

      # reading the whole file for now
      stock_data = CSV.read(csv_file_path)

      # getting the stock data 'title'
      @title = stock_data[0][0]

      # getting the stock data 'social reason'
      social_reason_data = stock_data[2][0]
      @social_reason = social_reason_data.split(':')[1].strip()

      # getting the stock data 'ticker'
      ticker_data = stock_data[3][0]
      @ticker = ticker_data.split(':')[1].strip()

      # getting the stock data 'series'
      series_data = stock_data[4][0]
      @series = series_data.split(':')[1].strip()

      # getting the stock data 'start date'
      start_date_data = stock_data[5][0]
      start_splitted = start_date_data.split(':')[1].split('/')
      month = start_splitted[0].to_i()
      day = start_splitted[1].to_i()
      year = start_splitted[2].to_i()
      @start_date = Date.new(year, month, day)

      # getting the stock data 'end date'
      end_date_data =  stock_data[6][0]
      end_splitted = end_date_data.split(':')[1].split('/')
      month = end_splitted[0].to_i()
      day = end_splitted[1].to_i()
      year = end_splitted[2].to_i()
      @end_date = Date.new(year, month, day)

      # getting 'facts'
      stock_data_count = stock_data.count()
      ub = stock_data_count - 1

      buyers_array = Array.new()
      sellers_array = Array.new()
      for i in 11..ub
        # getting the current row
        current_fact = stock_data[i]

        # storing raw facts information
        @facts << current_fact

        # adding current buyer to all registered buyers
        buyers_array << current_fact[2]

        # adding current seller to all registered sellers
        sellers_array << current_fact[3]
      end

      # storing the buyers and sellers
      @buyers = Set.new(buyers_array)
      @sellers = Set.new(sellers_array)
    end

end

# ---------------------------------------------------------------------------------

# represents a Json Stock Reader
class JsonStockReader < StockReader

  # JsonStockReader initializer
  def initialize(stock_source)
    # building parent
    super(stock_source)
  end

end

# ---------------------------------------------------------------------------------

# represents a Web Stock Reader
class WebStockReader < StockReader

  # WebStockReader initializer
  def initialize(stock_source)
    # building parent
    super(stock_source)
  end

end