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
    
  end
end

