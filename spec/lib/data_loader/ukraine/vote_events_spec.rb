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
end
