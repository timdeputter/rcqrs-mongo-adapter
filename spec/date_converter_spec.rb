describe "conversion of Date objects into mongo friendly types" do
  
  subject {RcqrsMongoAdapter::DateConverter}
  
  it "converts dates into time objects" do
    subject.new(Date.new(2012,2,2)).convert.should == Time.new(2012,2,2)
  end
  
end
