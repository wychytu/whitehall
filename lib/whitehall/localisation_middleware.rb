module Whitehall
  class LocalisationMiddleware
    attr_reader :path
    VALID_LOCALES = I18n.available_locales - %w(en)

    def initialize(app, _options = {})
      @app = app
    end

    def call(env)
      @path = env["PATH_INFO"]
      env["PATH_INFO"] = [base_path, format].compact.join(".")
      env["QUERY_STRING"] = querystring_with_locale(env, locale)

      @app.call(env)
    end

  private

    def locale
      elements = path.split(".")
      elements[1] if is_valid_locale?(elements[1])
    end

    def format
      elements = path.split(".").drop(1)
      elements.delete_at(0) if is_valid_locale?(elements[0])
      elements.join(".") if elements.any?
    end

    def is_valid_locale?(possible_locale)
      VALID_LOCALES.include?(possible_locale.to_sym) unless possible_locale.nil?
    end

    def base_path
      path.split(".").first
    end

    def querystring_with_locale(env, locale)
      parts = env["QUERY_STRING"].split("&")
      parts.unshift("locale=#{locale}") unless locale.nil?
      parts.join("&")
    end
  end
end
