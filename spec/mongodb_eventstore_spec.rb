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
    tim = TestEvent.new(name: "Tim")
    jim = TestEvent.new(name: "Jim")
    @store.store([published_event("aggregate",tim),
      published_event("aggregate",jim)])    
    inserted_data = @mongo.data
    inserted_data["aggregate_id"].should == "aggregate"
    inserted_data["data"].should ==nil      
    inserted_data["created_at"].should be_a Time
    events = inserted_data["events"]
    events[0].should == {"type" => "TestEvent", "published_at" => tim.published_at, "data" => {"name" => "Tim"}}
    events[1].should == {"type" => "TestEvent", "published_at" => jim.published_at, "data" => {"name" => "Jim"}}
  end
  
  it "stores the published time in a published_at column" do
    test_event = TestEvent.new(name: "Tim")
    test_event.store_publish_time
    @store.store([published_event("aggregate",test_event)])    
    @mongo.data["published_at"].should == test_event.published_at
  end
    
  def published_event(aggregate_id,event)
    Rcqrs::PublishedEvent.new(aggregate_id,event)
  end
  
  context "querying for a single event" do
    
    before do
      @mongo.data = {"data" => {"name" => "tim"},"published_at"=> DateTime.new(2012,2,2), "type" => "TestEvent"}
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
      @store.load_events("aggregate_id").first.published_at.should == DateTime.new(2012,2,2)    
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
