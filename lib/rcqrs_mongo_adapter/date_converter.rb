module RcqrsMongoAdapter
  
  class DateConverter
    
    def initialize to_convert
      @to_convert = to_convert
    end
    
    def convert
      @to_convert.to_time
    end
    
  end
  
end