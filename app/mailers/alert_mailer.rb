class AlertMailer < ActionMailer::Base
  default from: "#{Settings.project_name} <#{Settings.contact_email}>"
  layout 'email'
  helper PoliciesHelper, DivisionsHelper, PathHelper

  def policy_updated(policy, version, user)
    @policy, @version, @user = policy, version, user
    I18n.locale = Settings.default_locale
    mail to: user.email, subject: render_to_string(partial: 'policy_updated_subject')
  end
end
