require 'spec_helper'

describe DataLoader::Ukraine::People do
  before :each do
    # TODO: Work out why fixtures are loaded - we don't want them
    # Should we replace fixtures with factories throughout the tests?
    Person.delete_all
  end

  describe ".load!" do
    subject(:load_data) do
      DataLoader::Ukraine::People.new(
        RSpec.configuration.fixture_path + "/ep-popolo-v1.0_abridged.json"
      ).load!
    end

    it "creates new people" do
      load_data

      expect(Person.count).to eq 2
    end

    it "extracts the person’s rada id" do
      load_data

      expect(Person.first.id).to eq 15794
    end

    it "creates memberships for the people" do
      expected_constituency = "Миколаївська область"
      expected_party_name = "Група \"Партія \"Відродження\""
      expected_entered_house_date = Date.new(2015,06,17)

      load_data

      expect(Person.first.members.first.constituency).to eq expected_constituency
      expect(Person.first.members.first.party).to eq expected_party_name
      expect(Person.first.members.first.entered_house).to eq expected_entered_house_date
    end
  end
end
