require 'csv'
require 'set'

# ---------------------------------------------------------------------------------

# Remark: As a consensus, all the StockReaders will return the whole 'data stream.
#         The whole 'data stream' will be returned as an array of arrays where each
#         element of the outer array represents a row of the stock stream. The idea
#         behind this is to apply some sort of Dependency Injection from S.O.L.I.D.

# represents an abstract Stock Reader
class StockReader

  protected
    # represents the stock source
    @stock_source = nil

    # represents the whole data stream as an
    @data_stream = nil

    def read_from_source(stock_source)
      # empty --> this is like an abstract class method
    end

  public
    # StockReader initializer
    def initialize(stock_source)
      # checking if stock source is valid
      if stock_source.class != String
        raise Exception.new('The stock source must be a string.')
      end

      # storing the stock source value
      @stock_source = stock_source

      # initializing the data stream
      @data_stream = Array.new()

      # use threads here
      # reading information from source
      read_from_source(@stock_source)
    end

    def get_stock_source()
      return @stock_source
    end

    def get_data_stream()
      return @data_stream
    end

end

# ---------------------------------------------------------------------------------

# represents a Csv Stock Reader
class CsvStockReader < StockReader

  # it should be a class variable but rubymine gives me a warning
  @csv_suffix = '.csv'

  # CsvStockReader initializer
  def initialize(stock_source)
    # checking wether the stock source is a .csv file
    if CsvStockReader.csv_stock_source_is_invalid?(stock_source)
      raise Exception.new('The stock source must be a .csv file.')
    end

    # building parent
    super(stock_source)
  end

  # overriden methods
  def read_from_source(stock_source)
    read_from_csv(stock_source)
  end

  def CsvStockReader.csv_stock_source_is_invalid?(csv_stock_source)
    return !csv_stock_source.end_with?(@csv_suffix)
  end

  private
    def read_from_csv(csv_file_path)
      # reading the whole file for now
      stock_data = CSV.read(csv_file_path)

      # saving the stock data to the data_stream
      @data_stream = stock_data
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

# ---------------------------------------------------------------------------------