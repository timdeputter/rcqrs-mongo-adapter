require "spec_helper"

describe RcqrsMongoAdapter::Readmodeldatabase do
  
  before do
    @mongo = double("mongo")
    @mongo.stub!(collection: @mongo)
    @readmodel_db = RcqrsMongoAdapter::Readmodeldatabase.new(@mongo)
  end  
    
  it "allows to insert data into a readmodel" do
    on_collection("model").should_do(:insert).with({"name" => "tim"})
    @readmodel_db.insert(:model,{name: "tim"})
  end
  
  it "allows to find one element in a collection" do
    on_collection("some_model").should_do(:find_one).with({"lastname" => "de Putter"})
    @readmodel_db.find_one(:some_model,{lastname: "de Putter"})
  end
  
  it "allows to query for multiple elements" do
    on_collection("some_model").should_do(:find).with({"lastname" => "de Putter"})
    @readmodel_db.find(:some_model,{lastname: "de Putter"})    
  end
  
  it "should allow to specify sorting of query results" do
    @mongo.stub!(find: @mongo)
    on_collection("some_model").should_do(:find).with({"lastname" => "de Putter"})
    @mongo.should_receive(:sort).with(:lastname)
    @readmodel_db.find(:some_model,{"lastname" => "de Putter"},{sort: :lastname})        
  end
  
  it "converts the loaded data and returns it" do
    @mongo.stub!(:find).and_return("name" => "jojo")
    @readmodel_db.find(:some_model,{}).should == {:name => "jojo"}
  end
  
  it "allows to update data" do
    on_collection("some_model").should_do(:update).with({"lastname" => "de Putter"},{"lastname" => "Meyer"})
    @readmodel_db.update(:some_model,{lastname: "de Putter"},{lastname: "Meyer"})            
  end
  
  it "allows to delete all dataset fullfilling a criteria" do
    on_collection("some_model").should_do(:remove).with({"lastname" => "de Putter"})
    @readmodel_db.delete_all(:some_model,{lastname: "de Putter"})                
  end
  
  def on_collection(collection)
    @mongo.should_receive(:collection).with(collection)
    self    
  end
  
  def should_do(method)
    @mongo.should_receive(method)    
  end
  
end
