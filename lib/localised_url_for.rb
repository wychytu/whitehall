module LocalisedUrlFor
  def url_for(arg = nil)
    return super unless arg.is_a?(Hash)

    options = arg

    locale = options[:locale] || params[:locale] || I18n.locale
    locale = nil if locale.to_s == "en"

    if locale
      options[:locale] = locale
    else
      options.delete(:locale)
    end

    super(options)
  end
end
