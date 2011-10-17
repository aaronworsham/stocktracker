require "stocktracker/version"
require "stocktracker/yahoofinance"

module StockTracker

  def self.cache
    @cache ||= Redis.new
  end

  class CurrentQuote
    include YahooFinance

    def cache
      StockTracker.cache
    end

    attr_accessor :symbol, :results
    def initialize(symbol)
      self.symbol = symbol.upcase
      self.results = yahoo_quote
    end

    private

      def yahoo_quote
        if cache.exists(cache_key)
          Marshal.load(cache.get(cache_key))
        else
          results = YahooFinance::CurrentQuote.new(symbol).results
          cache.set(cache_key, Marshal.dump(results))
          cache.expire(cache_key, 600)
          results
        end
      end

      def cache_key
        "StockTracker:current:#{symbol}"
      end
  end

  class PastQuote
    include YahooFinance

    def cache
      StockTracker.cache
    end

    attr_accessor :symbol, :date, :results
    def initialize(symbol, date)
      self.symbol = symbol
      self.date = date
      self.results = yahoo_past_quote
    end

    private


      def yahoo_past_quote
        if cache.exists(cache_key)
          Marshal.load(cache.get(cache_key))
        else
          results = YahooFinance::PastQuote.new(symbol, date).results
          cache.set(cache_key, Marshal.dump(results))
          cache.expire(cache_key, 600)
          results
        end
      end

      def cache_key
        "StockTracker:past:#{symbol}:#{date.to_s}"
      end


  end
end
