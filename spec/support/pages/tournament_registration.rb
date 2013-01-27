class TournamentRegistration < GenericPage

  def visit
    Capybara::visit profile_path
  end

  def add_debate_team_details
    click_link 'Add debate team details'
    DebateTeamDetails.new
  end

  def edit_debate_team_details
    click_link 'Edit debate team details'
    DebateTeamDetails.new
  end

  def pay_via_paypal
    click_link 'Pay now via PayPal'
    PayPalFlow.new
  end

  def has_payment?
    has_css? '.payment-history'
  end

end
