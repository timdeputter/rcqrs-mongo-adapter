module RcqrsMongoAdapter
   
  class BaseConverter
    
    class << self
      
      def converts type
        @converts_type = type
      end
      
      def into type
        @into_type = type
      end
      
      def can_convert data, conversion_direction
        if(conversion_direction == :forward || @into_type == nil) 
          return data.kind_of? @converts_type
        else
          return data.kind_of? @into_type
        end
      end
      
    end    
    
    def initialize converters
      @converters = converters
    end
    
  end

end