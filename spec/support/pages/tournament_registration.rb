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

  def pay_via_paypal stubbed = false

    click_link 'Pay now via PayPal'

    if stubbed
      CompletedPaymentPage.new
    else
      PayPalFlow.new
    end
  end

  def has_manual_payment?
    has_css? '.manual-payment-history'
  end

  def has_paypal_payment?
    has_css? '.paypal-payment-history'
  end

end
