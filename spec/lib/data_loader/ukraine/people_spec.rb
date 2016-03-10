require 'spec_helper'

describe DataLoader::Ukraine::People do
  before :each do
    # TODO: Work out why fixtures are loaded - we don't want them
    # Should we replace fixtures with factories throughout the tests?
    Person.delete_all
  end

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
      expected_constituency = "Загальнодержавному багатомандатному округу"
      expected_party_name = "Фракція політичної партії \"Всеукраїнське об'єднання \"Батьківщина\" у Верховній Раді України"
      expected_entered_house_date = Date.new(2014,11,27)

      load_data

      expect(Person.first.members.first.constituency).to eq expected_constituency
      expect(Person.first.members.first.party).to eq expected_party_name
      expect(Person.first.members.first.entered_house).to eq expected_entered_house_date
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
      expected_constituency = "Загальнодержавному багатомандатному округу"
      expected_party_name = "Фракція політичної партії \"Всеукраїнське об'єднання \"Батьківщина\" у Верховній Раді України"
      expected_entered_house_date = Date.new(2014,11,27)

      load_data

      expect(Person.first.members.first.constituency).to eq expected_constituency
      expect(Person.first.members.first.party).to eq expected_party_name
      expect(Person.first.members.first.entered_house).to eq expected_entered_house_date
    end
  end
end
