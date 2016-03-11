require 'open-uri'

module DataLoader
  module Ukraine
    class People
      DEFAULT_EVERYPOLITICIAN_UKRAINE_URL = "https://raw.githubusercontent.com/everypolitician/everypolitician-data/master/data/Ukraine/Verkhovna_Rada/ep-popolo-v1.0.json"

      attr_accessor :data, :persons, :organizations, :areas, :events

      def initialize(url = nil)
        # If an Popolo file hasn't been specified as a parameter, try using
        # the DEBUG_URL environment variable (so you can set it from a Rake task),
        # or use the default URL for Ukraine EveryPolitician data.
        if url.nil?
          url = ENV["DEBUG_URL"] || DEFAULT_EVERYPOLITICIAN_UKRAINE_URL
        end

        @data = Everypolitician::Popolo.parse(open(url).read)

        @people = @data.persons
        @organizations = @data.organizations
        @areas = @data.areas
        @events = @data.events
        @members = @data.memberships
      end

      def load!
        Rails.logger.info "Loading #{@people.count} people..."
        @people.each do |p|
          id = extract_rada_id_from_person(p)
          person = Person.find_or_initialize_by(id: id)
          person.small_image_url = image_url(id)
          person.large_image_url = image_url(id)
          person.save!
        end

        Rails.logger.info "Loading #{@members.count} memberships..."
        @members.each do |m|
          raise "Person not found: #{m.person_id}" unless person = @people.find { |p| p.id == m.person_id }
          raise "Party not found: #{m.on_behalf_of_id}" unless party = @organizations.find { |o| o.id == m.on_behalf_of_id }
          raise "Area not found: #{m.area_id}" unless area = @areas.find { |a| a.id == m.area_id }
          raise "Legislative period not found: #{m.legislative_period_id}" unless legislative_period = @events.find { |e| e.id == m.legislative_period_id }
          person_rada_id = extract_rada_id_from_person(person)

          # Default to the start of the legislative period if there no specific one set for this membership
          start_date = m.start_date || legislative_period.start_date

          member = Member.find_or_initialize_by(person_id: person_rada_id, entered_house: start_date)
          member.gid = m.person_id
          member.source_gid = person_rada_id
          member.first_name = person.given_name
          member.last_name = person.family_name
          member.title = ""
          member.constituency = area.name
          member.party = party.name
          # TODO: Remove hardcoded house
          member.house = "rada"
          member.entered_house = start_date
          member.left_house = m.end_date if m.end_date
          member.person_id = person_rada_id
          member.save!
        end
      end

      private

      def extract_rada_id_from_person(person)
        person.identifier("rada")
      end

      def image_url(id)
        "https://s3.amazonaws.com/ukraine-verkhovna-rada-deputy-images/#{id}.jpg"
      end
    end
  end
end
