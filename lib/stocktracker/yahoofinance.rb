require 'open-uri'
require 'csv'


# modified version of YahooFinance gem by Nicholas Rahn <nick at transparentech.com>

#http://download.finance.yahoo.com/d/quotes.csv?s=%5EGDAXI&f=sl1d1t1c1ohgv&e=.csv
module YahooFinance

  class CurrentQuote

    attr_accessor :symbol, :results

    CURRENT_FORMAT = {
      "s"   =>  :symbol,
      "n"   =>  :name,
      "l1"  =>  [ :last_trade, "to_f" ],
      "d1"  =>  :date,
      "t1"  =>  :time,
      "c"   =>  :change,
      "c1"  =>  [ :change_points, "to_f" ],
      "p2"  =>  [ :change_percent, "to_f" ],
      "p"   =>  [ :previous_close, "to_f" ],
      "o"   =>  [ :open, "to_f" ],
      "h"   =>  [ :day_high, "to_f" ],
      "g"   =>  [ :day_low, "to_f" ],
      "v"   =>  [ :volume, "to_i" ],
      "m"   =>  :day_range,
      "l"   =>  :last_trade_with_time,
      "t7"  =>  :ticker_trend,
      "a2"  =>  [ :average_daily_volume, "to_i" ],
      "b"   =>  [ :bid, "to_f" ],
      "a"   =>  [ :ask, "to_f" ]
    }

    def initialize(symbol)
      self.symbol= symbol
      self.results= get_current_quote
    end

    def get_current_quote
      current_map
    rescue
      nil
    end

    def yahoo_quote
      open(yahoo_current_url).read
    end

    def yahoo_current_url
      URI.encode "http://download.finance.yahoo.com/d/quotes.csv?s=#{self.symbol}&f=#{current_format}"
    end

    def current_format
      CURRENT_FORMAT.keys.join
    end

    def current_values
      CSV.parse(yahoo_quote)[0]
    end

    def current_map
      map = {}
      values = current_values
      CURRENT_FORMAT.each_with_index do |v,i|
        if v[1].is_a?(Array)
          map[v[1][0]] = values[i].send(v[1][1])
        else
          map[v[1]] = values[i]
        end
      end
      map
    end
  end

  class PastQuote

    attr_accessor :symbol, :results, :start_date, :end_date

    PAST_FORMAT = [
      :date,
      [:open,"to_f"],
      [:high,"to_f"],
      [:low,"to_f"],
      [:close,"to_f"],
      [:volume,"to_f"],
      [:adj_close,"to_f"]
    ]

    def initialize(symbol, date)
      self.symbol= symbol
      self.start_date= date
      self.end_date= date
      self.results= get_past_quote
    end

    def get_past_quote
      past_map
    rescue
      nil
    end

    def yahoo_past_quote
      open(yahoo_past_url).read
    end

    def yahoo_past_url
      URI.encode(
        "http://itable.finance.yahoo.com/table.csv?"+
        "s=#{symbol}&g=d&"+
        "a=#{start_date.month-1}&"+
        "b=#{start_date.mday}&"+
        "c=#{start_date.year}&"+
        "d=#{end_date.month-1}&"+
        "e=#{end_date.mday}&"+
        "f=#{end_date.year}"
      )
    end


    def past_values
      CSV.parse(yahoo_past_quote)[1]
    end

    def past_map
      map = {}
      values = past_values
      PAST_FORMAT.each_with_index do |v,i|
        if v.is_a?(Array)
          map[v[0]] = values[i].send(v[1])
        else
          map[v] = values[i]
        end
      end
      map
    end
  end
end
