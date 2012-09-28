module RcqrsMongoAdapter
  
  class DateConverter < RcqrsMongoAdapter::BaseConverter
    
    converts Date
    into Time
    
    def convert to_convert
      Time.new(to_convert.year,to_convert.month,to_convert.day,12,0,0)
    end
  
    def convert_back to_convert
      to_convert.to_date
    end
      
  end
  
end