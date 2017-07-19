require "test_helper"

class LocalisedUrlForTest < ActiveSupport::TestCase
  class TestSuperclass
    attr_reader :passed_args, :locale

    def url_for(*args)
      @passed_args = args
      @locale = I18n.locale
    end
  end

  class TestClass < TestSuperclass
    def params
      {}
    end

    include LocalisedUrlFor
  end

  test "a locale of 'en' is not passed to super" do
    subject = TestClass.new
    subject.url_for(locale: "en")
    assert_equal [{}], subject.passed_args
  end

  test "a locale of something other than 'en' is passed to super" do
    subject = TestClass.new
    subject.url_for(locale: "fr")
    assert_equal [{ locale: "fr" }], subject.passed_args
  end

  test "locales can be symbols" do
    subject = TestClass.new
    subject.url_for(locale: :en)
    assert_equal [{}], subject.passed_args
  end

  test "other params are passed to super" do
    subject = TestClass.new
    subject.url_for(other: "param")
    assert_equal [{ other: "param" }], subject.passed_args
  end

  class LocalisedUrlForWithParamLocaleTest < ActiveSupport::TestCase
    test "passes locale from params" do
      subject = TestClass.new
      subject.stubs(:params).returns(locale: "fr")

      subject.url_for({})
      assert_equal [{ locale: "fr" }], subject.passed_args
    end

    test "gives precedence to explicit locale" do
      subject = TestClass.new
      subject.stubs(:params).returns(locale: "fr")

      subject.url_for({ locale: "de" })
      assert_equal [{ locale: "de" }], subject.passed_args
    end

    test "does not pass 'en' if params locale is 'en'" do
      subject = TestClass.new
      subject.stubs(:params).returns(locale: "en")

      subject.url_for({})
      assert_equal [{}], subject.passed_args
    end
  end

  class LocalisedUrlForWithI18nLocaleTest < ActiveSupport::TestCase
    test "passes locale from I18n.locale" do
      subject = TestClass.new
      I18n.stubs(:locale).returns("fr")

      subject.url_for({})
      assert_equal [{ locale: "fr" }], subject.passed_args
    end

    test "gives precedence to explicit locale, then params" do
      subject = TestClass.new

      I18n.stubs(:locale).returns("fr")
      subject.stubs(:params).returns(locale: "de")

      subject.url_for({ locale: "zh" })
      assert_equal [{ locale: "zh" }], subject.passed_args
    end

    test "does not pass 'en' if I18n locale is 'en'" do
      subject = TestClass.new
      I18n.stubs(:locale).returns("en")

      subject.url_for({})
      assert_equal [{}], subject.passed_args
    end
  end

#  class LocalisedUrlForWithObjectTest < ActiveSupport::TestCase
#    test "" do
#      subject = TestClass.new
#      subject.url_for(object)
#
#      assert_equal [object], subject.passed_args
#      assert_nil subject.locale
#    end
#  end
end
