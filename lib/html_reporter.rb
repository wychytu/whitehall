class HtmlReporter

  #end_month value is the last but one. e.g. if you choose:
  #the last 6 months then start_month = 6, end_month = 1 
  def initialize(start_month, end_month)
    @start_month = start_month
    @end_month = end_month
    @results = []
    get_monthly_html_docs_uploaded
  end

  def get_monthly_html_docs_uploaded
    @start_month.downto(@end_month) { |i|
      @results.push(HtmlAttachment.where(
        ["created_at between ? and ? ", i.months.ago, (i-1).months.ago]
      ).count)
    }
  end

  def average(result)
    result.inject{ |sum, el| sum + el }.to_f / result.size
  end

  def print_results
    count = 0
    @start_month.downto(@end_month) { |i|
      puts "#{i} months ago -  #{@results[count]} HTML documents were created"
      count +=1
    }
    puts "======================================================"
    puts "Average HTML documents uploaded (per month): #{average(@results)}"
  end
end
