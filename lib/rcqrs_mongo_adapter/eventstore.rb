
module RcqrsMongoAdapter

  class Eventstore
    
    def initialize(mongodb)
      @stored_events = mongodb.collection("StoredEvents")
    end
    
    def store(aggregate_id, event)
      puts "storing events in mongodb"
      s = Hash.new
      s[:aggregate_id] = aggregate_id
      s[:data] = event.data
      s[:created_at] = Time.new
      s[:type] = event.class.to_s
      @stored_events.insert(s)
    end
    
    def load_events(aggregate_id)
      puts "Eventstore.load_events 1"
      return @stored_events.find(:aggregate_id => aggregate_id).sort(:created_at).to_a.collect {|persisted_event| restore(persisted_event)}
      puts "Eventstore.load_events 2"
    end
    
    def restore(persisted_event)
      puts "Eventstore.restore #{persisted_event}"
      eval(persisted_event[:type]).restore_from(persisted_event[:data])
    end
    
  end  
  
end
