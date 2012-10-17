
module RcqrsMongoAdapter

  class Eventstore
    
    def initialize(mongodb)
      @stored_events = mongodb.collection("StoredEvents")
    end
    
    def store(events)
      if(events.size == 1)
        store_single_event(events.first)
      else
        store_multiple_events(events)
      end  
    end
    
    def store_single_event(event)
        s = Hash.new
        published_event = event
        s["aggregate_id"] = published_event.aggregate_id
        s["data"] = convert(published_event.event.data)
        s["created_at"] = Time.new
        s["type"] = published_event.event.class.to_s
        @stored_events.insert(s)
    end
    
    def store_multiple_events(events)
      get_events_grouped_by_aggregates(events).each do |k,v|
        store_events_for_aggregate(k,v)
      end
    end
    
    def get_events_grouped_by_aggregates(events)
      result = Hash.new
      events.each do |event|
        put_to_result(result,event)
      end
      return result
    end
    
    def store_events_for_aggregate(aggregate_id,events)
        record = Hash.new
        record["aggregate_id"] = aggregate_id
        record["events"] = events.collect{|e| {"type" => e.class.to_s, "data" => convert(e.data)}}
        record["created_at"] = Time.new
        @stored_events.insert(record)
    end
    
    def put_to_result(hash, event)
      unless(hash[event.aggregate_id])
        hash[event.aggregate_id] = Array.new
      end
      hash[event.aggregate_id] << event.event
    end
    
    def load_events(aggregate_id)
      return @stored_events.find("aggregate_id" => aggregate_id).sort("created_at").to_a.collect {|persisted_event| restore(persisted_event)}.flatten
    end
    
    def restore(record)
      if(record["events"])
        record["events"].collect{|e| restore_event(e)}
      else
        restore_event(record)
      end
    end
    
    def restore_event(persisted_event)
      eval(persisted_event["type"]).restore_from(convert_back(persisted_event["data"]))
    end
    
    def convert data
      RcqrsMongoAdapter::DatasetConverter.new.convert data      
    end
    
    def convert_back data
      RcqrsMongoAdapter::DatasetConverter.new.convert_back data
    end
    
  end  
  
end
