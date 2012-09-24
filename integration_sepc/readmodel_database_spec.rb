require "spec_helper"

describe "readmodel" do
  
  before do
    @mongodb = Mongo::Connection.new.db("test_db") 
    @readmodel_database = RcqrsMongoAdapter::Readmodeldatabase.new(@mongodb)
    @readmodel_database.delete_all(:readmodel_test,{})
  end
  
  it "allows to insert rows into the database" do
    @readmodel_database.insert(:readmodel_test,{test:"data"})
    @readmodel_database.find(:readmodel_test, {test:"data"}).first[:test].should == "data"
  end
  
  context "reading data" do
    
    before do
      @readmodel_database.insert(:readmodel_test,{name:"jim",test:"somedata"})      
      @readmodel_database.insert(:readmodel_test,{name:"jim",test:"data"})      
    end
    
    it "allows to specify a key to sort by" do
      result = @readmodel_database.find(:readmodel_test,{name:"jim"},{sort: :test})
      result[0][:test].should == "data"
      result[1][:test].should == "somedata"
    end
    
    it "returns all elements of a collection when no query hash is specified" do
      @readmodel_database.find(:readmodel_test).size.should == 2
    end
    
  end
  
end
