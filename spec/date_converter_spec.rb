describe "conversion of Date objects into mongo friendly types" do
  
  subject {RcqrsMongoAdapter::DateConverter}
  
  it "converts dates into time objects" do
    subject.new(Date.new(2012,2,2)).convert.should == Time.new(2012,2,2)
  end
  
  it "converts time objects back into dates when the hours, minutes and seconds are zero" do
    subject.new(Time.new(2012,2,2)).convert_back.should == Date.new(2012,2,2)    
  end
  
  it "does not convert times back into dates when the hours, minutes and seconds are not zero" do
    subject.new(Time.new(2012,2,2,12,30,30)).convert_back.should == Time.new(2012,2,2,12,30,30)        
  end
  
end
