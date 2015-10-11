module ApplicationHelper
  def es6_transform(es6_code = nil, &block)
    es6_code ||= capture(&block)
    js_code = Babel::Transpiler.transform(es6_code)["code"]
    js_code.html_safe #js code
    # javascript_tag js_code #js code with script tags
  end
end
