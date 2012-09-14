
module RcqrsMongoAdapter

  class Eventstore
    def initialize(mongodb)
      @stored_events = mongodb.collection("StoredEvents")
    end
    
    def store(aggregate_id, event)
      s = Hash.new
      s[:aggregate_id] = aggregate_id
      s[:data] = event.data
      s[:created_at] = Time.new
      s[:type] = event.class.to_s
      @stored_events.insert(s)
    end
    
    def self.load_events(aggregate_id)
      @stored_events.find(:aggregateroot_id => aggregate_id).order(:created_at).collect {|event| Rcqrs::BaseEvent.new(event.data)}
    end
    
  end  
end
