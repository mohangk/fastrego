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

  def payment_details
    payment_details = find('.payment-items')

    raise 'No payment details section' if payment_details.nil?

    def payment_details.has_preregistration_fees?
      r = rows.select { |row| row[:key] =~ /Pre registration fees/}
      r.count == 1
    end

    def payment_details.rows
      all('tr').map do |row|
        cols = []
        row.all('td').each do |col|
          cols << col.text()
        end
        { key: cols[0], value: cols[1] }
      end
    end

    payment_details
  end
end

