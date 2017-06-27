require 'date'

class UploadedHtmlDocumentsReporter
  attr_reader :start_date, :end_date, :frequency

  def initialize(start_date:, end_date:, frequency:)
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @frequency = frequency

    if @end_date < @start_date
      raise ("End date can not be earlier than start date!")
    end

    if @frequency != "daily" && @frequency != "weekly" && @frequency != "monthly"
      raise("Frequency options are: 'daily', 'weekly' or 'monthly'")
    end
  end

  def calculate
    @results = []
    date = @start_date

    until date > @end_date
      case @frequency
      when "daily"
        freq_date_end = date
      when "weekly"
        freq_date_end = date.next_week
      when "monthly"
        freq_date_end = date.next_month
      end

      freq_date_end = @end_date if freq_date_end > @end_date

      data = {start: date, end: freq_date_end}
      total  = 0
      until date > freq_date_end do
        total = total + HtmlAttachment.where(["created_at between ? and ? ", date, date.next_day]).count
        date = date.next_day
      end

      data[:total] = total
      @results.push(data)

      date = (freq_date_end).next_day
    end
    @results
  end

  def average(result)
    result.inject{ |sum, el| sum + el }.to_f / result.size
  end

  def print_results
    @results.each do |result|
      puts "From #{result[:start]} to #{result[:end]} the number of HTML documents uploaded were #{result[:total]}"
    end

    totals = @results.collect { |result| result[:total]}.flatten
    puts "Average HTML documents uploaded (#{@frequency}): #{average(totals)}"
  end
end
