require "spec_helper"

describe RcqrsMongoAdapter::DatasetConverter do
  
  subject {RcqrsMongoAdapter::DatasetConverter.new}
  
  context "Conversion of keys in data_sets to strings" do
  
    it "in hashtables" do
      subject.convert({name:"Hello"}).should == {"name" => "Hello"}
    end
    
    it "in hashtables within hashtables" do
      subject.convert({sub:{name:"myname"}}).should == {"sub" => {"name" => "myname"}}    
    end
    
    it "in hashtables within arrays within hashtables" do
      subject.convert({array:["schatzi",{herzi: "steffi"}]}).should == {"array" => ["schatzi",{"herzi" => "steffi"}]}
    end
    
    it "in hashtables within arrays" do
      subject.convert([{jojo:"huhu"}]).should == [{"jojo" => "huhu"}]      
    end
    
  end
  
  context "Conversion of string-keys back into symbols" do

    it "in hashtables" do
      subject.convert_back({"name" => "Hello"}).should == {name:"Hello"} 
    end
    
    it "in hashtables within hashtables" do
      subject.convert_back({"sub" => {"name" => "myname"}}).should == {sub:{name:"myname"}}    
    end
    
    it "in hashtables within arrays within hashtables" do
      subject.convert_back({"array" => ["schatzi",{"herzi" => "steffi"}]}).should == {array:["schatzi",{herzi: "steffi"}]} 
    end
    
    it "in arrays within hashtables" do
      subject.convert_back([{"jojo" => "huhu"}]).should == [{jojo:"huhu"}]      
    end
    
  end
  
  context "conversion of dates" do
  
    it "creates time instances" do
      subject.convert([{date: Date.new(2013,3,3)}]).should == [{"date" => Time.new(2013,3,3)}]
    end
  
    it "back creates date instances" do
      subject.convert_back([{"date" => Time.new(2013,3,3)}]).should == [{date: Date.new(2013,3,3)}]      
    end
    
  end
  
end

