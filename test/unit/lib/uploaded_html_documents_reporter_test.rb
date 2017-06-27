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
      end_date: end_date,
      frequency: "weekly"
    )
    expected = [
      {:start=>Date.parse("Tue, 30 May 2017"), :end=>Date.parse("Thu, 01 Jun 2017"), :total=>0}
    ]

    assert_equal expected, reporter.calculate
  end

  test "it should return one when there is a document created within the given dates" do
    start_date = '25/05/2017'
    end_date = '28/06/2017'

    reporter = UploadedHtmlDocumentsReporter.new(
      start_date: start_date,
      end_date: end_date,
      frequency: "monthly"
    )
    expected = [
      {:start=>Date.parse("Thu, 25 May 2017"), :end=>Date.parse("Sun, 25 Jun 2017"), :total=>1},
      {:start=>Date.parse("Mon, 26 Jun 2017"), :end=>Date.parse("Wed, 28 Jun 2017"), :total=>0}
    ]

    assert_equal expected, reporter.calculate
  end

  test "it should return two when there are documents created within the given dates" do
    start_date = '01/01/2016'
    end_date = '06/06/2017'

    reporter = UploadedHtmlDocumentsReporter.new(
      start_date: start_date,
      end_date: end_date,
      frequency: "monthly"
    )

    expected = [
      {:start=>Date.parse("Fri, 01 Jan 2016"), :end=>Date.parse("Mon, 01 Feb 2016"), :total=>0},
      {:start=>Date.parse("Tue, 02 Feb 2016"), :end=>Date.parse("Wed, 02 Mar 2016"), :total=>1},
      {:start=>Date.parse("Thu, 03 Mar 2016"), :end=>Date.parse("Sun, 03 Apr 2016"), :total=>0},
      {:start=>Date.parse("Mon, 04 Apr 2016"), :end=>Date.parse("Wed, 04 May 2016"), :total=>0},
      {:start=>Date.parse("Thu, 05 May 2016"), :end=>Date.parse("Sun, 05 Jun 2016"), :total=>0},
      {:start=>Date.parse("Mon, 06 Jun 2016"), :end=>Date.parse("Wed, 06 Jul 2016"), :total=>0},
      {:start=>Date.parse("Thu, 07 Jul 2016"), :end=>Date.parse("Sun, 07 Aug 2016"), :total=>0},
      {:start=>Date.parse("Mon, 08 Aug 2016"), :end=>Date.parse("Thu, 08 Sep 2016"), :total=>0},
      {:start=>Date.parse("Fri, 09 Sep 2016"), :end=>Date.parse("Sun, 09 Oct 2016"), :total=>0},
      {:start=>Date.parse("Mon, 10 Oct 2016"), :end=>Date.parse("Thu, 10 Nov 2016"), :total=>0},
      {:start=>Date.parse("Fri, 11 Nov 2016"), :end=>Date.parse("Sun, 11 Dec 2016"), :total=>0},
      {:start=>Date.parse("Mon, 12 Dec 2016"), :end=>Date.parse("Thu, 12 Jan 2017"), :total=>0},
      {:start=>Date.parse("Fri, 13 Jan 2017"), :end=>Date.parse("Mon, 13 Feb 2017"), :total=>0},
      {:start=>Date.parse("Tue, 14 Feb 2017"), :end=>Date.parse("Tue, 14 Mar 2017"), :total=>0},
      {:start=>Date.parse("Wed, 15 Mar 2017"), :end=>Date.parse("Sat, 15 Apr 2017"), :total=>0},
      {:start=>Date.parse("Sun, 16 Apr 2017"), :end=>Date.parse("Tue, 16 May 2017"), :total=>0},
      {:start=>Date.parse("Wed, 17 May 2017"), :end=>Date.parse("Tue, 06 Jun 2017"), :total=>1}
    ]

    assert_equal expected, reporter.calculate
  end

  test "it should fail if start and end dates are not date types" do
    start_date = 'A'
    end_date = '11/2017'

    assert_raise ArgumentError do
      UploadedHtmlDocumentsReporter.new(
        start_date: start_date,
        end_date: end_date,
        frequency: "weekly"
      )
    end
  end

  test "it should raise an error when end date is before start date" do
    start_date = '11/06/2017'
    end_date = '10/02/2017'

    assert_raise RuntimeError do
      UploadedHtmlDocumentsReporter.new(
        start_date: start_date,
        end_date: end_date,
        frequency: "monthly"
      )
    end
  end

  test "it should raise an error if frequency is not valid text" do
    start_date = '11/06/2017'
    end_date = '10/02/2017'

    assert_raise RuntimeError do
      UploadedHtmlDocumentsReporter.new(
        start_date: start_date,
        end_date: end_date,
        frequency: "anytime"
      )
    end
  end

  test "it should receive date types" do
    start_date = '10/02/2017'
    end_date = '11/06/2017'

    reporter = UploadedHtmlDocumentsReporter.new(
      start_date: start_date,
      end_date: end_date,
      frequency: "monthly"
    )

    assert reporter.start_date, kind_of(Date)
    assert reporter.end_date, kind_of(Date)
  end

  test "it receives start and end dates" do
    start_date = '10/02/2017'
    end_date = '11/06/2017'

    reporter = UploadedHtmlDocumentsReporter.new(
      start_date: start_date,
      end_date: end_date,
      frequency: "monthly"
    )

    assert_equal reporter.start_date, Date.parse(start_date)
    assert_equal reporter.end_date, Date.parse(end_date)
  end


end
