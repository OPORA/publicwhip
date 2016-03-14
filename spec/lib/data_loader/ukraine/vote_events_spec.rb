require 'spec_helper'

describe DataLoader::Ukraine::VoteEvents do
  describe "#url" do
    it "generates the URL when passed a date" do
      data_loader = DataLoader::Ukraine::VoteEvents.new(
        Date.new(2016,03,14),
        nil
      )

      expect(data_loader.url).to eq "https://arcane-mountain-8284.herokuapp.com/vote_events/2016-03-14"
    end

    it "uses the specified url if no date is specified" do
      data_loader = DataLoader::Ukraine::VoteEvents.new(
        nil,
        "http://example.com"
      )

      expect(data_loader.url).to eq "http://example.com"
    end

    it "when no date or url are specified it raises an error" do
      data_loader = DataLoader::Ukraine::VoteEvents.new(
        nil,
        nil
      )

      expect{ data_loader.url }.to raise_error "date or url not specified"
    end
  end

  describe "#popolo_to_publicwhip_vote" do
    subject(:data_loader) { DataLoader::Ukraine::VoteEvents.new() }

    it { expect(data_loader.popolo_to_publicwhip_vote("yes")).to eq "aye" }
    it { expect(data_loader.popolo_to_publicwhip_vote("no")).to eq "no" }
    it { expect(data_loader.popolo_to_publicwhip_vote("abstain")).to eq "abstention" }
    it { expect(data_loader.popolo_to_publicwhip_vote("absent")).to be_nil }
    it { expect(data_loader.popolo_to_publicwhip_vote("not voting")).to eq "not voting" }
    it { expect{ data_loader.popolo_to_publicwhip_vote("foo") }.to raise_error "Unknown vote option: foo" }
  end
end
