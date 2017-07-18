require "test_helper"

class Whitehall::LocalisationMiddlewareTest < Minitest::Test
  def setup
    @app = stub
    @subject = Whitehall::LocalisationMiddleware.new(@app)
  end

  def test_path_with_no_locale_is_not_affected
    @app.expects(:call).with(
      "PATH_INFO" => "/example/path",
      "QUERY_STRING" => ""
    )

    @subject.call("PATH_INFO" => "/example/path", "QUERY_STRING" => "")
  end

  def test_path_with_only_format_is_not_affected
    @app.expects(:call).with(
      "PATH_INFO" => "/example/path.json",
      "QUERY_STRING" => ""
    )

    @subject.call("PATH_INFO" => "/example/path.json", "QUERY_STRING" => "")
  end

  def test_path_with_locale_is_removed
    @app.expects(:call).with(
      "PATH_INFO" => "/example/path",
      "QUERY_STRING" => "locale=fr"
    )

    @subject.call("PATH_INFO" => "/example/path.fr", "QUERY_STRING" => "")
  end

  def test_path_with_locale_and_format
    @app.expects(:call).with(
      "PATH_INFO" => "/example/path.json",
      "QUERY_STRING" => "locale=fr"
    )

    @subject.call("PATH_INFO" => "/example/path.fr.json", "QUERY_STRING" => "")
  end

  def test_querystring_params_are_passed_through
    @app.expects(:call).with(
      "PATH_INFO" => "/example/path.json",
      "QUERY_STRING" => "locale=fr&boo=yah&kah=sha",
    )

    @subject.call(
      "PATH_INFO" => "/example/path.fr.json",
      "QUERY_STRING" => "boo=yah&kah=sha",
    )
  end
end
