require 'date'

class UploadedHtmlDocumentsReporter
  attr_reader :start_date, :end_date

  def initialize(start_date:, end_date:)
    @start_date = Date.parse(start_date).beginning_of_day
    @end_date = Date.parse(end_date).end_of_day

    if @end_date < @start_date
      raise ("End date can not be earlier than start date!")
    end
  end

  def calculate
    HtmlAttachment.where(["created_at between ? and ? ", @start_date, @end_date]).count
  end

  def get_monthly_html_docs_uploaded
    puts "hello"
    date = @start_date

    until date <= @end_date do
      @results.push(HtmlAttachment.where(["created_at between ? and ? ", date, date.prev_month]).count)
      date = date.prev_month
    end
   puts @results
  end

  def average(result)
    result.inject{ |sum, el| sum + el }.to_f / result.size
  end

  def print_results
    count = 0
    @start_date.downto(@end_date) { |i|
      puts "#{i} months ago -  #{@results[count]} HTML documents were created"
      count +=1
    }
    puts "======================================================"
    puts "Average HTML documents uploaded (per month): #{average(@results)}"
  end
end

#raise error is end date is before start date
