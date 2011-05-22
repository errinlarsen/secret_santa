require 'spec_helper'

module SecretSanta
  describe Matchmaker do
    let(:input_lines) do
      """
      Luke Skywalker   <luke@theforce.net>
      Leia Skywalker   <leia@therebellion.org>
      Toula Portokalos <toula@manhunter.org>

      Gus Portokalos   <gus@weareallfruit.net>
      Bruce Wayne      <bruce@imbatman.com>
      Virgil Brigman   <virgil@rigworkersunion.org>

      Lindsey Brigman  <lindsey@iseealiens.net>
      
      """.split("\n").each(&:strip!)
    end
    let(:mm) { Matchmaker.new(input_lines) }


    describe "#new" do
      it "should raise an error if called without an array" do
        bad_input_lambda = lambda { Matchmaker.new("not an Array") }
        bad_input_lambda.should raise_error "Input needs to be an Array of Strings"
      end

      it "should raise an error if called with an Array of elements that aren't strings" do
        bad_input_lambda = lambda { Matchmaker.new([1,2]) }
        bad_input_lambda.should raise_error "Input needs to be an Array of Strings"
      end

      it "should raise an error if input array has less than 2 entries" do
        bad_input = ["Luke Skywalker    <luke@theforce.net>"]
        bad_input_lambda = lambda { Matchmaker.new(bad_input) }
        bad_input_lambda.should raise_error "Input needs at least 2 entries"
      end

      it "should raise an error if the same participant's name was input twice" do
        bad_input = [
          "Luke Skywalker    <luke@theforce.net>",
          "Luke Skywalker    <luke@sometimes_bad.net>"
        ]
        bad_input_lambda = lambda { Matchmaker.new(bad_input) }
        bad_input_lambda.should raise_error "Each unique name may only be entered once"
      end

      it "should raise an error if a Participant has no potential matches" do
        bad_input = 
          """
          Virgil Brigman   <virgil@rigworkersunion.org>
          Lindsey Brigman  <lindsey@iseealiens.net>
        
          """.split("\n").each(&:strip!)
        bad_input_lambda = lambda { Matchmaker.new(bad_input) }
        bad_input_lambda.should raise_error /No potential matches found for/
      end
    end


    describe "#pick_matches" do
    end


    describe "#results" do
      it "should return an Array" do
        mm.results.should be_an_instance_of(Array)
      end

      it "should not be empty" do
        mm.results.should_not be_empty
      end

      it "should contain Participants" do
        number_expected = mm.results.count
        number_found = mm.results.select { |p| p.instance_of?(Participant) }.count
        number_found.should == number_expected
      end

      it "should have targets assigned to each Participant" do
        number_expected = mm.results.count
        number_found = mm.results.reject { |p| p.target.nil? }.count
        number_found.should == number_expected
      end

      it "should have targets that are also Participants" do
        number_expected = mm.results.count
        number_found = mm.results.select { |p| p.target.instance_of?(Participant) }.count
        number_found.should == number_expected
      end

      it "should not have the same Participant twice" do
        mm.results.count.should == mm.results.uniq.count
      end

      it "should not assign the same target twice" do
        mm.results.map(&:target).count.should == mm.results.map(&:target).count
      end

      it "should not assign a target to a participant with the same last name" do
        mm.results.any? { |p| p.target.lname == p.lname }.should be_false
      end
    end
  end
end
