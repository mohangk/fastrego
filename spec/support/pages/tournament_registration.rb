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

  def has_manual_payment?
    has_css? '.manual-payment-history'
  end

  def has_paypal_payment?
    has_css? '.paypal-payment-history'
  end

  def pay_via_paypal stubbed = false
    click_link 'Pay now via PayPal'

    if stubbed
      CompletedPaymentPage.new
    else
      PayPalFlow.new
    end
  end

  def payment_details
    payment_details = find('.payment-items')

    def payment_details.pre_registration_row
      r = rows.select { |row| row[0] =~ /Pre registration fees/}
      if r.count == 1
        r.first
      end
    end

    def payment_details.has_preregistration_fees?
      !pre_registration_row.nil?
    end


    def payment_details.has_preregistration_paypal_link?
      return false if !has_preregistration_fees?
      return true if pre_registration_row[2] =~ /PayPal/
      false
    end


    def payment_details.click_preregistration_paypal_link
      click_on 'Pay pre registration now via PayPal'
      CompletedPaymentPage.new
    end

    def payment_details.rows
      all('tr').map do |row|
        cols = []
        row.all('td').each do |col|
          if col.has_css?('a')
            cols << col.all('a').first['title']
          else
            cols << col.text()
          end
        end
        cols
      end
    end

    payment_details
  end
end

