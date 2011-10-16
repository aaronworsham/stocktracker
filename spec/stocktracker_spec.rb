require 'spec_helper'

describe StockTracker  do
  context :quote do
    context :current do
      before(:each) do
        @quote = StockTracker::CurrentQuote.new("GOOG")
      end
      it "will return a current quote for Google" do
        @quote.results.should be
        @quote.results["symbol"].should == "GOOG"
      end

      it 'will have a close greater than 0' do
        @quote.results["lastTrade"].should > 0
      end
    end

    context :historical do
      before(:each) do
        @quote = StockTracker::HistoricalQuote.new("GOOG", Date.parse('01/10/2010'), Date.parse('01/10/2010'))
      end
      it "will return a current quote for Google" do
        @quote.results.should be
      end

      it 'will have a close greater than 0' do
        @quote.results["Close"].should > 0
      end
    end
  end
end