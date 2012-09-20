require "spec_helper"

describe "Conversion of keys in data_sets to strings" do
  
  subject {RcqrsMongoAdapter::KeysToStringsConverter}
  
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
