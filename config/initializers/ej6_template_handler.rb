class ES6TemplateHandler
  def self.erb_handler
    @@erb_handler ||= ActionView::Template.registered_template_handler(:erb)
  end

  def self.call(template)
    compiled_source = erb_handler.call(template)
    "Babel::Transpiler.transform(begin;#{compiled_source};end)['code'].html_safe"
  end
end

ActiveSupport.on_load(:action_view) do
  ActionView::Template.register_template_handler :es6, ES6TemplateHandler
end
