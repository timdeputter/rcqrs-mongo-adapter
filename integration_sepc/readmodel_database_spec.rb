describe "readmodel" do
  
  before do
    @mongodb = Mongo::Connection.new.db("ship") 
    @readmodel_database = RcqrsMongoAdapter::Readmodeldatabase.new(@mongodb)
  end
  
end
