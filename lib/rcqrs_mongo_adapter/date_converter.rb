module RcqrsMongoAdapter
  
  class DateConverter
    
    def initialize to_convert
      @to_convert = to_convert
    end
    
    def convert
      @to_convert.to_time
    end
  
    def convert_back
      return @to_convert.to_date if(@to_convert.sec == 0 && @to_convert.min == 0 && @to_convert.hour == 0)
      @to_convert
    end  
  end
  
end