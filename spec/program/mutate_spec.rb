require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Revolve
  
describe Program, "#mutate" do
  before do
    @parent = Program.new(1, 2, 3, 4, 5)
    @mutation = Program.new("one", "two", "three", "four", "five")
    @child = @parent.mutate(@mutation)
  end
  
  it "should produce a new Program" do
    @child.should be_kind_of(Program)
  end
  
  it "should be of length no greater than the sum of the program and its mutation" do
    @child.length.should_not > 10
  end
  
  it "should only contain instructions from either program or mutation" do
    @child.each{|instruction| (@parent + @mutation).should include(instruction) }
  end
end
  
end