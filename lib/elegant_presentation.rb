module AdminView::ElegantPresentation    def render_context_with(attr)
    condition = controller.respond_to?("render_context_condition") ? controller.render_context_condition : true
    nspace  = controller.class.namespace ? "#{controller.class.namespace}_" : ""
    if condition
      html  = "#{@parent.class} > "
      html << link_to(@parent.send(attr), controller.send("#{nspace}#{@parent.class.to_s.downcase}_path", @parent))
      html  = content_tag(:div, html, :id => :context)
    else
      html = ""
    end
    html
  end
  
  def resource_context_path
    nspace  = controller.class.namespace ? "#{controller.class.namespace}/" : ""
    "#{nspace}#{@parent.class.to_s.downcase.pluralize}/context"
  end
  
  def related_info_for(group, links=[])
    html = content_tag('h3', group)
    lis  = ""
    links.each do |link|
      lis << content_tag('li', link_to(link[:link], link[:url], :method => link[:method] || nil))
    end
    html << content_tag('ul', lis)
    content_tag('div', html, :class => 'related_info')
  end   
  
  def simple_list(highlight, description)
    html = ""
    unless @records.blank?
      for item in @records
        str  = content_tag('h3', item.send(highlight))
        str << content_tag('span', item.send(description)) unless description.blank?
        str  = content_tag('div', str)
        str  = link_to(str, path_to_element(item))
        html << content_tag('li', str, :class => cycle('odd', 'even'))
      end
      content_tag('ul', html, :class => 'list')
    else
      render_empty_msg
    end
  end
  
  def render_empty_msg
    content_tag('div', 'No hay registros cargados', :class => 'msg')
  end
  
  def render_action_label
    case controller.action_name
      when "new"
        label = "Nuevo registro de #{controller.controller_name.humanize}"
      when "edit"
        label = "Editando un registro de #{controller.controller_name.humanize}"      
    end
    content_tag('div', label, :class => 'section_label')
  end
  
end

ActionView::Base.send :include, AdminView::ElegantPresentation
