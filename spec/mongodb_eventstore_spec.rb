require "spec_helper"

class TestEvent < Rcqrs::BaseEvent
  
end

class DummyMongo
   
  attr_reader :name, :data, :ordering, :query
    
  def collection(name)
    @name = name
    self
  end
  
  def insert(data)
    @data = data
  end
  
  def find(query)
    @query = query
    self
  end

  def order(ordering)
    @ordering = ordering
    self
  end
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
      @mongo.stub!(:order)
    end
    
  end
  
  
end
