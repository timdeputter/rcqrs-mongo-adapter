
module RcqrsMongoAdapter

  class Eventstore
    
    def initialize(mongodb)
      @stored_events = mongodb.collection("StoredEvents")
    end
    
    def store(aggregate_id, event)
      s = Hash.new
      s["aggregate_id"] = aggregate_id
      s["data"] = event.data
      s["created_at"] = Time.new
      s["type"] = event.class.to_s
      @stored_events.insert(s)
    end
    
    def load_events(aggregate_id)
      return @stored_events.find("aggregate_id" => aggregate_id).sort("created_at").to_a.collect {|persisted_event| restore(persisted_event)}
    end
    
    def restore(persisted_event)
      eval(persisted_event["type"]).restore_from(convert_back(persisted_event["data"]))
    end
    
    def convert_back(data)
      RcqrsMongoAdapter::DatasetConverter.new.convert_back data
    end
    
  end  
  
end
