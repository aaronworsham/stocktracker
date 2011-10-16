require "stocktracker/version"
require "yahoofinance"
require "stocktracker/yahoofinance"

module StockTracker
  class CurrentQuote


    attr_accessor :symbol, :results
    def initialize(symbol)
      self.symbol = symbol
      self.results = yahoo_quote
    end

    private

      def yahoo_quote
        YahooFinance::get_quotes(YahooFinance::StandardQuote, symbol)[symbol].values
      end
  end

  class HistoricalQuote
    HISTORIC_ROWS = ["Date","Open","High","Low","Close","Volume","Adjusted Close"]

    attr_accessor :symbol, :start_date, :end_date, :results
    def initialize(symbol, start_date, end_date)
      self.symbol = symbol
      self.start_date = start_date
      self.end_date = end_date
      self.results = yahoo_historical_quote
    end

    private

      def yahoo_historical_quote
        map_rows(YahooFinance::get_historical_quotes(symbol, start_date, end_date))
      end

      def map_rows(results)
        map = {}
        results[0].each_with_index do |r, i|
          map[HISTORIC_ROWS[i]] = r.to_f
        end
        map
      end

  end
end
