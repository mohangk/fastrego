class AdminListRow
  def initialize rowElem
    @rowElem = rowElem
  end

  def columns
    @rowElem.all 'td'
  end

  def click_show
    click_action 'Show'
    GenericPage.new
  end

  def click_edit
    click_action 'Edit'
    GenericPage.new
  end

  def action_column
    columns.last
  end

  def has_action?(action_name)
    action_names = action_column.all('a').map {|link| link.text() }
    action_names.member?(action_name)
  end

  def click_action action_name
    action_link = action_column.all('a').select {|link| link.text() == action_name}.first
    raise "Cannot find action '#{action_name}'" if action_link.nil?
    action_link.click
  end
end

class AdminListPage < GenericPage

  @@row_class = AdminListRow

  def data_rows
    rows = []
    all('tr').each_with_index do |r, index|
      next if index == 0
      rows << @@row_class.new(r)
    end
    rows
  end

  def header_row
    all 'tr:first'
  end

end
