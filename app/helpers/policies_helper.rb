module PoliciesHelper
  def policies_list_sentence(policies)
    policies.map do |policy|
      text = link_to h(policy.name), policy
      text += " ".html_safe + content_tag(:i, "(draft)") if policy.provisional?
      text
    end.to_sentence.html_safe
  end

  def policy_agreement_summary_without_html(policy_member_distance)
    policy_agreement_summary(policy_member_distance).gsub("<strong>", "").gsub("</strong>", "")
  end

  # Returns things like "voted strongly against", "has never voted on", etc..
  def policy_agreement_summary(policy_member_distance)
    if policy_member_distance.nil?
      "voted <strong>unknown about</strong>".html_safe
    elsif policy_member_distance.number_of_votes == 0
      if I18n.locale == :uk
        "<strong>ніколи не голосував</strong>".html_safe
      else
        "has <strong>never voted</strong> on".html_safe
      end
    else
      text = ranges.find{|r| r.first.include?(policy_member_distance.agreement_fraction)}.second
      if I18n.locale == :uk
        content_tag(:strong, text.html_safe)
      else  
        "voted ".html_safe + content_tag(:strong, text.html_safe)
      end  
    end
  end

  # TODO This shouldn't really be in a helper should it? It smells a lot like "business" logic
  def ranges
    {
      0.95..1.00 => _("very strongly for"),
      0.85..0.95 => _("strongly for"),
      0.60..0.85 => _("moderately for"),
      0.40..0.60 => _("a mixture of for and against"),
      0.15..0.40 => _("moderately against"),
      0.05..0.15 => _("strongly against"),
      0.00..0.05 => _("very strongly against")
    }
  end

  def quote(word)
    "“#{word}”"
  end

  def policy_version_sentence(version, options)
    if version.event == "create"
      name = version.changeset["name"].second
      description = version.changeset["description"].second
      result = _("Created")
      result += version.changeset["private"].second == 2 ? _(" draft ") : " "
      result += _("policy ") + quote(name) + _(" with description ") + quote(description)
      result = content_tag(:p, result + ".", class: 'change-action')
    elsif version.event == "update"
      changes = []

      if version.changeset.has_key?("name")
        name1 = version.changeset["name"].first
        name2 = version.changeset["name"].second
        changes << _("Name changed from ") + quote(name1) + _(" to ") + quote(name2)
      end

      if version.changeset.has_key?("description")
        description1 = version.changeset["description"].first
        description2 = version.changeset["description"].second
        if I18n.locale == :uk
          changes << "Опис змінено з " + quote(description1) + " на " + quote(description2)
        else
          changes << "Description changed from " + quote(description1) + " to " + quote(description2)
        end

      end

      if version.changeset.has_key?("private")
        if version.changeset["private"].second == 0
          changes << _("Changed status to not draft")
        elsif version.changeset["private"].second == 2
          changes << _("Changed status to draft")
        else
          raise
        end
      end

      result = changes.map do |change|
        content_tag(:p, change + ".", class: 'change-action')
      end.join
    else
      raise
    end
    result.html_safe
  end

  def policy_version_sentence_text(version)
    if version.event == "create"
      name = version.changeset["name"].second
      description = version.changeset["description"].second
      result = _("Created")
      result += version.changeset["private"].second == 2 ? _(" draft ") : " "
      result += _("policy ") + quote(name) + _(" with description ") + quote(description)
      result += "."
    elsif version.event == "update"
      changes = []

      if version.changeset.has_key?("name")
        name1 = version.changeset["name"].first
        name2 = version.changeset["name"].second
        changes << "name from " + quote(name1) + _(" to ") + quote(name2)
      end

      if version.changeset.has_key?("description")
        description1 = version.changeset["description"].first
        description2 = version.changeset["description"].second
        changes << "description from " + quote(description1) + _(" to ") + quote(description2)
      end

      if version.changeset.has_key?("private")
        if version.changeset["private"].second == 0
          changes << _("status to not draft")
        elsif version.changeset["private"].second == 2
          changes << _("status to draft")
        else
          raise
        end
      end

      result = changes.map do |change|
        "* " + _("Changed") + " " + change + "."
      end.join("\n")
    else
      raise
    end
    result
  end

  def policy_division_version_vote(version)
    if version.event == "create"
      policy_vote_display_with_class(version.changeset["vote"].second)
    elsif version.event == "destroy"
      policy_vote_display_with_class(version.reify.vote)
    elsif version.event == "update"
      text = policy_vote_display_with_class(version.changeset["vote"].first)
      text += _(" to ").html_safe
      text += policy_vote_display_with_class(version.changeset["vote"].second)
      text
    end
  end

  def policy_division_version_vote_text(version)
    if version.event == "create"
      vote_display(version.changeset["vote"].second)
    elsif version.event == "destroy"
      vote_display(version.reify.vote)
    elsif version.event == "update"
      vote_display(version.changeset["vote"].first) + _(" to ") + vote_display(version.changeset["vote"].second)
    end
  end

  def policy_division_version_division(version)
    id = version.event == "create" ? version.changeset["division_id"].second : version.reify.division_id
    Division.find(id)
  end

  def policy_division_version_sentence(version, options)
    actions = {"create" => _("Added"), "destroy" => _("Removed"), "update" => _("Changed")}
    vote = policy_division_version_vote(version)
    division = policy_division_version_division(version)

    if version.event == "update"
      actions[version.event].html_safe + _(" vote from ").html_safe + vote + _(" on division ").html_safe + content_tag(:em, link_to(division.name, division_path(division, options))) + ".".html_safe
    elsif version.event == "create" || version.event == "destroy"
      if version.event == "create"
        tense = _("set to ")
      else
        tense = _("was ")
      end
      actions[version.event].html_safe + _(" division ").html_safe + content_tag(:em, link_to(division.name, division_path(division, options))) + _(". Policy vote ").html_safe + tense + vote + ".".html_safe
    else
      raise
    end
  end

  def policy_division_version_sentence_text(version, options)
    actions = {"create" => _("Added"), "destroy" => _("Removed"), "update" => _("Changed")}
    vote = policy_division_version_vote_text(version)
    division = policy_division_version_division(version)

    if version.event == "update"
      actions[version.event] + _(" vote from ") + vote + _(" on division ") + division.name + ".\n" + division_path(division, options)
    elsif version.event == "create" || version.event == "destroy"
      if version.event == "create"
        tense = _("set to ")
      else
        tense = _("was ")
      end
      actions[version.event] + (" division ") + division.name + _(". Policy vote ") + tense + vote + ".\n" + division_path(division, options)
    else
      raise
    end
  end

  def version_policy(version)
    Policy.find(version.policy_id)
  end

  def version_attribution_sentence(version)
    user = User.find(version.whodunnit)
    time = time_ago_in_words(version.created_at)
    ("by " + link_to(user.name, user) + ", " + time + " ago").html_safe
  end

  def version_sentence(version, options = {})
    if version.item_type == "Policy"
      policy_version_sentence(version, options)
    elsif version.item_type == "PolicyDivision"
      content_tag(:p, policy_division_version_sentence(version, options), class: 'change-action')
    end
  end

  def version_sentence_text(version, options = {})
    if version.item_type == "Policy"
      policy_version_sentence_text(version)
    elsif version.item_type == "PolicyDivision"
      policy_division_version_sentence_text(version, options)
    end
  end

  def version_author_link(version, options = {})
    if version.kind_of?(WikiMotion)
      link_to version.user.name, user_path(version.user, options)
    else
      user = User.find(version.whodunnit)
      link_to user.name, user_path(user, options)
    end
  end

  def version_attribution_text(version)
    if version.kind_of?(WikiMotion)
      "By #{version.user.name} at #{@version.created_at.strftime("%I:%M%p - %d %b %Y")}\n#{user_path(version.user, only_path: false)}"
    else
      user = User.find(version.whodunnit)
      "By #{user.name} at #{@version.created_at.strftime("%I:%M%p - %d %b %Y")}\n#{user_path(user, only_path: false)}"
    end
  end

  def capitalise_initial_character(text)
    text[0].upcase + text[1..-1]
  end
end
