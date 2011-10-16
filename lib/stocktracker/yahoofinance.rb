module YahooFinance
  class StandardQuote
    def values
      ret = {}
      @formathash.each_value do |val|
        ret[val[0]] = send( val[0] ) unless send( val[0] ) == nil
      end
      ret
    end
  end
end