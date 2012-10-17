require "spec_helper"

class TestEvent < Rcqrs::BaseEvent
  
end

describe RcqrsMongoAdapter::Eventstore do
  
  before do
    @mongo = DummyMongo.new
    @store = RcqrsMongoAdapter::Eventstore.new(@mongo)
  end
    
  it "stores events in a StoredEvents collection" do
    @store.store([Rcqrs::PublishedEvent.new("aggregate",TestEvent.new)])
    @mongo.name.should == "StoredEvents"
  end
  
  it "creates a dataset with the aggregate-id,data,create_time and the type of the event if only a single event is stored" do
    @store.store([published_event("aggregate",TestEvent.new(name: "Tim"))])
    inserted_data = @mongo.data
    inserted_data["aggregate_id"].should == "aggregate"
    inserted_data["data"].should == {"name" => "Tim"}
    inserted_data["created_at"].should be_a Time
    inserted_data["type"].should == "TestEvent"
  end
  
  it "creates one dataset for all events of a aggregate when multiple events are passed in" do
    @store.store([published_event("aggregate",TestEvent.new(name: "Tim")),
      published_event("aggregate",TestEvent.new(name: "Jim"))])    
    inserted_data = @mongo.data
    inserted_data["aggregate_id"].should == "aggregate"
    inserted_data["data"].should ==nil      
    inserted_data["created_at"].should be_a Time
    events = inserted_data["events"]
    events[0].should == {"type" => "TestEvent", "data" => {"name" => "Tim"}}
    events[1].should == {"type" => "TestEvent", "data" => {"name" => "Jim"}}
  end
  
  def published_event(aggregate_id,event)
    Rcqrs::PublishedEvent.new(aggregate_id,event)
  end
  
  context "querying for a single event" do
    
    before do
      @mongo.data = {"data" => {"name" => "tim"}, "type" => "TestEvent"}
    end
        
    it "queries for the events for the given aggregate_id" do
      @store.load_events("aggregate_id")
      @mongo.query.should == {"aggregate_id" => "aggregate_id"}
    end
    
    it "orders the result by create time" do
      @store.load_events("aggregate_id")
      @mongo.ordering.should == "created_at"      
    end
    
    it "restores the events" do
      @store.load_events("aggregate_id").should == [TestEvent.new(name: "tim")]      
    end
    
  end
  
  context "querying for multiple events" do
    
    before do
      @mongo.data = {"events" => [{"data" => {"name" => "tim"}, "type" => "TestEvent"}]}
    end
    
    it "restores the events" do
      @store.load_events("aggregate_id").should == [TestEvent.new(name: "tim")]      
    end

  end
  
end
