require 'spec_helper'

describe DataLoader::Ukraine::People do
  describe ".load!" do
    subject(:load_data) do
      VCR.use_cassette('everypolitician') do
        DataLoader::Ukraine::People.new.load!
      end
    end

    it "creates new people" do
      load_data

      expect(Person.count).to eq 443
    end

    it "extracts the person’s rada id" do
      load_data

      expect(Person.first.id).to eq 386
    end

    it "creates memberships for the people" do
      load_data

      expect(Person.first.members.count).to eq 1
    end
  end

  describe ".load_using_everypolitician_gem!" do
    subject(:load_data) do
      VCR.use_cassette('everypolitician', record: :new_episodes) do
        DataLoader::Ukraine::People.new.load_using_everypolitician_gem!
      end
    end

    it "creates new people" do
      load_data

      expect(Person.count).to eq 443
    end

    it "extracts the person’s rada id" do
      load_data

      expect(Person.first.id).to eq 386
    end

    it "creates memberships for the people" do
      load_data

      expect(Person.first.members.count).to eq 1
    end
  end
end
