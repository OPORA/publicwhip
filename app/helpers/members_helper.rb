module MembersHelper
  # Also say "whilst Independent" if they used to be in a different party
  def party_long2(member)
    if member.entered_reason == "changed_party" || member.left_reason == "changed_party"
      result = "whilst ".html_safe
    else
      result = "".html_safe
    end
    result += link_to member.party_name, party_divisions_path(member.party_object)
    result
  end

  def vote_class(vote)
    if vote.nil?
      ""
    elsif vote.rebellion?
      "rebel"
    else
      ""
    end
  end

  def member_party_type_place_name(member)
    result = member.party_name + " " + member.role + " " + member.name

    member.currently_in_parliament? ? result : "Former " + result
  end

  def member_type_party_place_sentence(member)
    # TODO: if not a senator, add the state after the electorate. e.g. Goldstein, Vic
    if member.currently_in_parliament?
      member_type_party_place_sentence_without_former(member)
    else
      # FIXME: Translate this in a nicer way
      if I18n.locale == :uk
        content_tag(:span, "Вибув #{member.party_name} у Верховній Раді України обраний по #{content_tag(:span, member.electorate, class: "electorate")}".html_safe, class: 'title')
      else
        content_tag(:span, "Former #{member.party_name} #{member_type(member.house)} for #{content_tag(:span, member.electorate, class: "electorate")}".html_safe, class: 'title')
      end
    end.html_safe
  end

  def member_type_party_place_sentence_without_former(member)
    # FIXME: Translate this in a nicer way
    if I18n.locale == :uk
      if member.electorate[/в Раду за списком партії/]
        content_tag(:span, member.party_name.gsub(/у Верховній Раді України/,''), class: 'org') + ", " + content_tag(:span, "обрано в #{content_tag(:span, member.electorate.gsub(/обраний в/,''), class: "electorate")}".html_safe, class: 'title')
      else
        content_tag(:span, member.party_name.gsub(/у Верховній Раді України/,''), class: 'org') + ", " + content_tag(:span, "обрано по #{content_tag(:span, member.electorate, class: "electorate")}".html_safe, class: 'title')
      end
    else
      content_tag(:span, member.party_name, class: 'org') + " " + content_tag(:span, "#{member_type(member.house)} for #{content_tag(:span, member.electorate, class: "electorate")}".html_safe, class: 'title')
    end
  end

  def member_type_party_place_date_sentence(member)
    text = member_type_party_place_sentence(member)
    if member.currently_in_parliament?
      if I18n.locale == :uk
        text += (" " +
        content_tag(:span, _("since %{date}") % {date: member.since}) + " року").html_safe
      else
        text += (" " +
        content_tag(:span, _("since %{date}") % {date: member.since}, class: 'member-period')).html_safe
      end
    else
      if I18n.locale == :uk
        text += (" " +
        content_tag(:span, "#{member.since} – #{member.until}")).html_safe
      else
        text += (" " +
        content_tag(:span, "#{member.since} – #{member.until}", class: 'member-period')).html_safe
      end
    end
    text
  end  

  def member_history_sentence(member)
    text = "Before being #{member_type_party_place_sentence_without_former(member)}, #{member.name_without_title} was "
    text += member.person.members.order(entered_house: :desc).offset(1).map do |member, i|
      member.party_name + " " + member_type(member.house) + " for " + content_tag(:span, member.electorate, class: 'electorate')
    end.to_sentence
    text.html_safe + "."
  end

  def ukrainian_party_display_name_first(name)
    name.gsub(/( у Верховній Раді України| восьмого скликання|Фракція)/,'')
  end

  def ukrainian_party_display_name_second(name)
    name.gsub(/( у Верховній Раді України| восьмого скликання| партії Фракція|Фракція)/,'')
  end

end
