require "spec_helper"

class TestEvent < Rcqrs::BaseEvent
  
end

describe RcqrsMongoAdapter::Eventstore do
  
  before do
    @mongo = DummyMongo.new
    @store = RcqrsMongoAdapter::Eventstore.new(@mongo)
  end
    
  it "stores events in a StoredEvents collection" do
    @store.store("aggregate",TestEvent.new)
    @mongo.name.should == "StoredEvents"
  end
  
  it "creates a dataset with the aggregate-id,create_time and the type of the event" do
    @store.store("aggregate",TestEvent.new(name: "Tim"))
    inserted_data = @mongo.data
    inserted_data[:aggregate_id].should == "aggregate"
    inserted_data[:data].should == {name: "Tim"}
    inserted_data[:created_at].should be_a Time
    inserted_data[:type].should == "TestEvent"
  end
  
  context "querying of events" do
    
     before do
       @mongo.data = {data: {name: "tim"}, type: "TestEvent"}
     end
        
    it "queries for the events for the given aggregate_id" do
      @store.load_events("aggregate_id")
      @mongo.query.should == {aggregate_id: "aggregate_id"}
    end
    
    it "orders the result by create time" do
      @store.load_events("aggregate_id")
      @mongo.ordering.should == :created_at      
    end
    
    it "restores the events" do
      @store.load_events("aggregate_id").should == [TestEvent.new(name: "tim")]      
    end
    
  end
  
  
end
