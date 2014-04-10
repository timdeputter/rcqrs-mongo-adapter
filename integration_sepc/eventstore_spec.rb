require "spec_helper"

describe "eventstore" do

  let(:mongodb){Mongo::Connection.new.db("test_db")}
  let(:eventstore){RcqrsMongoAdapter::Eventstore.new(mongodb)}

  before do
    mongodb["StoredEvents"].remove
  end

  class TestEvent < Rcqrs::BaseEvent; end
  
  it "allows to save a single event" do
    eventstore.store([Rcqrs::PublishedEvent.new("aggregate",TestEvent.new)])
    eventstore.load_events("aggregate").size.should == 1
  end

  it "allows to store multiple events" do
    events = (1..5).map { Rcqrs::PublishedEvent.new("aggregate",TestEvent.new)}.to_a
    eventstore.store events
    eventstore.load_events("aggregate").size.should == 5
  end

end
