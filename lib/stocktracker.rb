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

  class MockCurrentQuote

    attr_accessor :symbol, :results
    def initialize(symbol)
      self.symbol = symbol.upcase
      self.results =
        {
          :symbol=>"GOOG",
          :name=>"Google Inc.",
          :last_trade=>633.14,
          :date=>"12/23/2011",
          :time=>"4:00pm",
          :change=>"+3.44 - +0.55%",
          :change_points=>3.44,
          :change_percent=>0.55,
          :previous_close=>629.7,
          :open=>632.0,
          :day_high=>634.68,
          :day_low=>630.56,
          :volume=>1453723,
          :day_range=>"630.56 - 634.68",
          :last_trade_with_time=>"Dec 23 - <b>633.14</b>",
          :ticker_trend=>"&nbsp;======&nbsp;",
          :average_daily_volume=>3109540,
          :bid=>632.15,
          :ask=>633.93
        }
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

  class MockPastQuote

    attr_accessor :symbol, :date, :results
    def initialize(symbol, date)
      self.symbol = symbol
      self.date = date
      self.results =
        {
          :date=>"2011-12-20",
          :open=>628.0,
          :high=>631.84,
          :low=>627.99,
          :close=>630.37,
          :volume=>2388200.0,
          :adj_close=>630.37
        }
    end
  end
end
