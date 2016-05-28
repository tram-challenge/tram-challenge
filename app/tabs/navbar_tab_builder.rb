class NavbarTabBuilder < TabsOnRails::Tabs::Builder
  def open_tabs(options = {})
    options[:class] ||= "nav navbar-nav"
    @context.tag("ul", options, open = true)
  end

  def close_tabs(options = {})
    "</ul>".html_safe
  end

  def tab_for(tab, name, options, item_options = {})
    li_options = {}
    if current_tab?(tab)
      li_options[:class] = "active"
    end

    @context.content_tag(:li, li_options) do
      @context.link_to(name, options, item_options)
    end
  end
end
