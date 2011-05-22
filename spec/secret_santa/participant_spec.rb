require 'spec_helper'

module SecretSanta
  describe Participant do
    let(:input) { "Luke Skywalker   <luke@theforce.net>" }
    let(:participant) { Participant.new(input) }

    describe "#new" do
      it "should raise an error if the input string is in the wrong format" do
        bad_input = "Luke    <luke@theforce.net>"
        bad_input_lambda = lambda { participant = Participant.new(bad_input) }
        bad_input_lambda.should raise_error "Participants must be entered in the following format: FIRST_NAME LAST_NAME <EMAIL_ADDRESS>"
      end
    end

    describe "#fname" do
      it "should return a string" do
        participant.fname.should be_an_instance_of(String)
      end

      it "should not be empty" do
        participant.fname.should_not be_empty
      end

      it "should be the same as the first word in the input" do
        participant.fname.should == input.split.first
      end
    end


    describe "#lname" do
      it "should return a string" do
        participant.lname.should be_an_instance_of(String)
      end

      it "should not be empty" do
        participant.lname.should_not be_empty
      end

      it "should be the same as the second word in the input" do
        participant.lname.should == input.split[1]
      end
    end


    describe "#email" do
      it "should return a string" do
        participant.email.should be_an_instance_of(String)
      end

      it "should not be empty" do
        participant.email.should_not be_empty
      end

      it "should be the same as the third word in the input, without arrow brackets" do
        participant.email.should == input.split[2].gsub(/[<>]/,"")
      end
    end


    describe "#matches_with?" do
      it "should return true when called without a family member" do
        other = Participant.new("Toula Portokalos <toula@manhunter.org>")
        participant.matches_with?(other).should be_true
      end

      it "should return false when called with itself" do
        participant.matches_with?(participant).should be_false
      end

      it "should return false when called with a family member" do
        family = Participant.new("Leia Skywalker   <leia@therebellion.org>")
        participant.matches_with?(family).should be_false
      end
    end

    describe "#to_s" do
      it "should return a string in the proper format" do
        other = Participant.new("Toula Portokalos <toula@manhunter.org>")
        participant.target = other
        participant.to_s.should == "Luke Skywalker <luke@theforce.net> => Toula Portokalos"
      end
    end
  end
end
