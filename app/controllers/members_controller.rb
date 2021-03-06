class MembersController < ApplicationController
  def index_redirect
    redirect_to members_path(
      house: (params[:house] && params[:house] != "all" ? params[:house] : "representatives"),
      sort: (params[:sort] if params[:sort] != "lastname"))
  end

  def index
    @sort = params[:sort]
    @house = params[:house]

    members = Member.current.group(:gid)
    if @house
      raise ActiveRecord::RecordNotFound unless House.valid?(@house)
      members = members.in_house(@house)
    end
    members = members.includes(:member_info, person: [members: :member_info] )

    @members = case @sort
    when "constituency"
      members.order(:constituency, :last_name, :first_name, :party)
    when "party"
      members.order(:party, :last_name, :first_name, :constituency)
    when "rebellions"
      # FIXME: Because this sort isn't done in the database the name won't correctly sort in some languages such as Ukrainian
      members.to_a.sort_by { |m| [-(m.person.rebellions_fraction || -1), m.last_name, m.first_name, m.constituency, m.party, -m.entered_house.to_time.to_i] }
    when "attendance"
      # FIXME: Because this sort isn't done in the database the name won't correctly sort in some languages such as Ukrainian
      members.to_a.sort_by { |m| [-(m.person.attendance_fraction || -1), m.last_name, m.first_name, m.constituency, m.party, -m.entered_house.to_time.to_i] }
    else
      members.order(:last_name, :first_name, :constituency, :party)
    end
  end

  def show_redirect
    if params[:mpid] || params[:id] || params[:mpc] == "Senate" || params[:mpc].nil? || params[:house].nil?
      if params[:mpid]
        member = Member.find_by!(id: params[:mpid])
      elsif params[:id]
        member = Member.find_by!(gid: params[:id])
      elsif params[:mpc] == "Senate" || params[:mpc].nil? || params[:house].nil?
        member = Member.with_name(params[:mpn].gsub("_", " "))
        member = member.in_house(params[:house]) if params[:house]
        member = member.order(entered_house: :desc).first
        if member.nil?
          render 'member_not_found', status: 404
          return
        end
      end
      redirect_to params.merge(
          only_path: true,
          mpn: member.url_name,
          mpc: member.url_electorate,
          house: member.house,
          mpid: nil,
          id: nil
        ).to_h
      return
    end
    if params[:dmp] && params[:display] == "allvotes"
      redirect_to params.merge(only_path: true, display: nil).to_h
      return
    end
    if params[:display] == "summary" || params[:display] == "alldreams"
      redirect_to params.merge(only_path: true, display: nil).to_h
      return
    end
    if params[:display] == "allvotes" || params[:showall] == "yes"
      redirect_to params.merge(only_path: true, showall: nil, display: "everyvote").to_h
    end
  end

  def friends
    electorate = electorate_param
    name = params[:mpn].gsub("_", " ")

    @member = Member.with_name(name)
    @member = @member.in_house(params[:house])
    @member = @member.where(constituency: electorate)
    @member = @member.order(entered_house: :desc).first

    render 'member_not_found', status: 404 if @member.nil?
  end

  def show
    name = params[:mpn].gsub("_", " ")
    electorate = electorate_param

    @member = Member.with_name(name)
    @member = @member.in_house(params[:house])
    @member = @member.where(constituency: electorate)
    @member = @member.order(entered_house: :desc).first

    render 'member_not_found', status: 404 if @member.nil?

    unless @member.nil?
      @rebellions_or_nil_with_member = []
      @member.person.members.order(entered_house: :desc).each do |member|
        if member.divisions_possible.any?
          member.rebellious_divisions.order(date: :desc, clock_time: :desc, name: :asc).each do |division|
            @rebellions_or_nil_with_member << { division: division, member: member }
          end
        end
      end
      @rebellions_or_nil_with_member = @rebellions_or_nil_with_member.first(3)
    end
  end
  def show_mp
    @member = Member.where(person_id: params[:mpi].to_i)
    @member = @member.order(entered_house: :desc).first
    render 'member_not_found', status: 404 if @member.nil?
    unless @member.nil?
      params[:mpc] = @member.constituency
      electorate = electorate_param
      redirect_to(member_path(:house => @member.house, :mpc => electorate, :mpn => "#{@member.first_name}_#{@member.last_name}"))
    end
  end
end
