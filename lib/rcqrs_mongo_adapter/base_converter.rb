module RcqrsMongoAdapter
   
  class BaseConverter
    
    class << self
      def converts type
        @converts = type
      end
      
      def can_convert type
        @converts == type
      end
    end    
    
    def initialize converters
      @converters = converters
    end
    
  end

end