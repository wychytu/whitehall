require 'fast_test_helper'

class UploadedHtmlDocumentsReporterTest < ActiveSupport::TestCase
  def setup
    Timecop.freeze(2017, 05, 27) do
      @html_document_1 = create(:html_attachment)
    end

    Timecop.freeze(2016, 02, 02) do
      @html_document_2 = create(:html_attachment)
    end
  end

  test "it should return zero when there no documents created in the given dates" do
    start_date = '30/05/2017'
    end_date = '01/06/2017'

    reporter = UploadedHtmlDocumentsReporter.new(
      start_date: start_date,
      end_date: end_date
    )

    assert_equal 0, reporter.calculate
  end

  test "it should return one when there is a document created within the given dates" do
    start_date = '25/05/2017'
    end_date = '28/06/2017'

    reporter = UploadedHtmlDocumentsReporter.new(
      start_date: start_date,
      end_date: end_date
    )

    assert_equal 1, reporter.calculate
  end

  test "it should return two when there are documents created within the given dates" do
    start_date = '01/01/2016'
    end_date = '06/06/2017'

    reporter = UploadedHtmlDocumentsReporter.new(
      start_date: start_date,
      end_date: end_date
    )

    assert_equal 2, reporter.calculate
  end

  test "it should fail if start and end dates are not date types" do
    start_date = 'A'
    end_date = '11/2017'

    assert_raise ArgumentError do
      UploadedHtmlDocumentsReporter.new(
        start_date: start_date,
        end_date: end_date
      )
    end
  end

  test "it should raise an error when end date is before start date" do
    start_date = '11/06/2017'
    end_date = '10/02/2017'

    assert_raise RuntimeError do
      UploadedHtmlDocumentsReporter.new(
        start_date: start_date,
        end_date: end_date
      )
    end
  end

  test "it should receive date types" do
    start_date = '10/02/2017'
    end_date = '11/06/2017'

    reporter = UploadedHtmlDocumentsReporter.new(
      start_date: start_date,
      end_date: end_date
    )

    assert reporter.start_date, kind_of(Date)
    assert reporter.end_date, kind_of(Date)
  end

  test "it receives start and end dates" do
    start_date = '10/02/2017'
    end_date = '11/06/2017'

    reporter = UploadedHtmlDocumentsReporter.new(
      start_date: start_date,
      end_date: end_date
    )

    assert_equal reporter.start_date, Date.parse(start_date).beginning_of_day
    assert_equal reporter.end_date, Date.parse(end_date).end_of_day
  end


end
