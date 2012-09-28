describe "conversion of Date objects into mongo friendly types" do
  
  subject {RcqrsMongoAdapter::DateConverter.new(nil)}
  
  it "converts dates into time objects" do
    subject.convert(Date.new(2012,2,2)).should == Time.new(2012,2,2,12,0,0)
  end
  
  it "converts time objects back into dates, ignoring their time" do
    subject.convert_back(Time.new(2012,2,2)).should == Date.new(2012,2,2)    
    subject.convert_back(Time.new(2012,2,2,12,30,30)).should == Date.new(2012,2,2)       
  end
  
end
