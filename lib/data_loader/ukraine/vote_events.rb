module DataLoader
  module Ukraine
    class VoteEvents
      DEFAULT_BASE_URL = "https://scrapervoted.rada4you.org/vote_events/"

      attr_accessor :specified_date, :specified_url

      def initialize(specified_date = nil, specified_url = nil)
        @specified_date = specified_date
        @specified_url = specified_url
      end

      def url
        if specified_date
          DEFAULT_BASE_URL + specified_date.to_s
        elsif specified_url
          specified_url
        else
          raise "date or url not specified"
        end
      end

      def load!
        data = DataLoader::Ukraine::Popolo.load(url)
        vote_events = data.popolo[:vote_events]

        Rails.logger.info "Loading #{vote_events.count} vote_events..."
        vote_events.each do |v_e|
          ActiveRecord::Base.transaction do
            division = Division.find_or_initialize_by(number: v_e[:identifier], date: DateTime.parse(v_e[:start_date]).strftime("%F") )
            division.house = v_e[:organization_id]
            division.name = v_e[:title]
            division.source_url = v_e[:sources].find { |s| s[:note] == "Source URL" }[:url]
            division.debate_url = v_e[:sources].find { |s| s[:note] == "Debate URL" }[:url]
            division.motion = ""
            division.clock_time = DateTime.parse(v_e[:start_date]).strftime("%T")
            division.source_gid = v_e[:identifier]
            division.debate_gid = ""
            division.result = v_e[:result]
            division.save!

            votes = v_e[:votes]
            Rails.logger.info "Loading #{votes.count} votes..."
            possible_members = Member.current_on(division.date)
            division.votes.destroy_all
            votes.each do |v|
              member = possible_members.find_by!(person_id: v[:voter_id])

              if option = popolo_to_publicwhip_vote(v[:option])
                division.votes.create!(member: member, vote: option)
              end
            end

            bills = v_e[:bills]
            Rails.logger.info "Loading #{bills.count} bills..."
            bills.each do |b|
              # We need to use create here because otherwise the association isn't saved
              bill = Bill.find_or_create_by(official_id: b[:official_id], title: b[:title])
              bill.divisions << division
              bill.url = b[:url]
              bill.save!
            end
          end
        end
      end

      def popolo_to_publicwhip_vote(string)
        case string
        when "yes"
          "aye"
        when "no"
          "no"
        when "abstain"
          "abstention"
        when "absent"
          nil
        when "not voting"
          "not voting"
        else
          raise "Unknown vote option: #{string}"
        end
      end
    end
  end
end
