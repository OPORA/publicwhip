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

  describe "#load!" do
    before :each do
      # Fix the Database Cleaner setup so this isn’t required
      Member.delete_all
      Person.delete_all
      Division.delete_all
      Vote.delete_all

      person1 = create(:person, id: 123)
      person2 = create(:person, id: 456)
      create(:member, first_name: "Jane", person: person1)
      create(:member, first_name: "Ming", person: person2)
    end

    subject(:load_data) do
      path = RSpec.configuration.fixture_path + "/popolo_vote_events.json"
      DataLoader::Ukraine::VoteEvents.new(nil, path).load!
    end

    it "creates divisions" do
      load_data

      expect(Division.count).to eq 2
    end

    it "creates votes" do
      load_data

      expect(Vote.count).to eq 3
    end

    it "assigns votes to divisions" do
      load_data

      expect(Division.find(6064).votes.count).to eq 2
    end

    it "assigns votes to members" do
      member_who_voted = Person.find(456).latest_member

      load_data

      expect(Division.find(6063).vote_for(member_who_voted)).to eq "aye"
    end

    it "creates bills" do
      expected_bill_name = "Проект Закону про ратифікацію Протоколу про сталий транспорт до Рамкової конвенції про охорону та сталий розвиток Карпат"

      load_data

      expect(Bill.find_by_official_id("0081").title).to eq expected_bill_name
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
