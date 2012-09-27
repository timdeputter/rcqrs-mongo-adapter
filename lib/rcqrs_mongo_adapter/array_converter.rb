module RcqrsMongoAdapter
   
  class ArrayConverter < RcqrsMongoAdapter::BaseConverter
    
    converts Array
    
    def convert array
      array.collect {|element| @converters.convert(element)}.to_a
    end
    
    def convert_back array
      array.collect {|element| @converters.convert_back(element)}.to_a      
    end
    
  end

end
