ActiveAdmin::Dashboards.build do
  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  #section "Current registration quantities" do
  #  table_for([ 'debate_teams', 'adjudicators', 'observers' ].each)do |t|
  #    t.column("Type") { |role| role.titleize }
  #    t.column("Requested") { |role| Registration.sum("#{role}_requested")}
  #    t.column("Granted") { |role|   Registration.sum("#{role}_granted")}
  #    t.column("Confirmed") { |role| Registration.sum("#{role}_confirmed")}
  #  end
  #end  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  section "Current registration quantities" do
    roles = [ 'debate_teams', 'adjudicators', 'observers' ]    
    stages = ['', 'requested', 'granted', 'confirmed'] 
    table do
      tr do  
        stages.each do |stage|
          th stage.titleize
        end
      end 
      roles.each do |role|
        tr do
          td role.titleize
          td Registration.sum("#{role}_requested")
          td Registration.sum("#{role}_granted")  
          td Registration.sum("#{role}_confirmed")
        end
      end
    end
  end

  #section "Recent Posts" do
  #  ul do
  #    Post.recent(5).collect do |post|
  #      li link_to(post.title, admin_post_path(post))
  #    end
  #  end
  #end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

end
