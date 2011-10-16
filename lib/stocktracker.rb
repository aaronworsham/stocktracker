require "stocktracker/version"
require "stocktracker/yahoofinance"

module StockTracker
  class CurrentQuote
    include YahooFinance


    attr_accessor :symbol, :results
    def initialize(symbol)
      self.symbol = symbol.upcase
      self.results = yahoo_quote
    end

    private

      def yahoo_quote
        YahooFinance::CurrentQuote.new(symbol).results
      end
  end

  class PastQuote
    include YahooFinance

    attr_accessor :symbol, :date, :results
    def initialize(symbol, date)
      self.symbol = symbol
      self.date = date
      self.results = yahoo_historical_quote
    end

    private

      def yahoo_historical_quote
        YahooFinance::PastQuote.new(symbol, date).results
      end

  end
end
