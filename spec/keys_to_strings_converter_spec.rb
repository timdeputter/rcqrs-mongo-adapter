require "spec_helper"

describe RcqrsMongoAdapter::KeysToStringsConverter do
  
  subject {RcqrsMongoAdapter::KeysToStringsConverter}
  
  context "Conversion of keys in data_sets to strings" do
  
    it "in hashtables" do
      subject.new({name:"Hello"}).convert.should == {"name" => "Hello"}
    end
    
    it "in hashtables within hashtables" do
      subject.new({sub:{name:"myname"}}).convert.should == {"sub" => {"name" => "myname"}}    
    end
    
    it "in hashtables within arrays within hashtables" do
      subject.new({array:["schatzi",{herzi: "steffi"}]}).convert.should == {"array" => ["schatzi",{"herzi" => "steffi"}]}
    end
    
  end
  
  context "Conversion of string-keys back into symbols" do

    it "in hashtables" do
      subject.new({"name" => "Hello"}).convert_back.should == {name:"Hello"} 
    end
    
    it "in hashtables within hashtables" do
      subject.new({"sub" => {"name" => "myname"}}).convert_back.should == {sub:{name:"myname"}}    
    end
    
    it "in hashtables within arrays within hashtables" do
      subject.new({"array" => ["schatzi",{"herzi" => "steffi"}]}).convert_back.should == {array:["schatzi",{herzi: "steffi"}]} 
    end
    
  end
end

