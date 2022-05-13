class Utility
  # date always contain date of day Monday
  def self.week_contains_3rd_wednesday?(date)
    date == (third_wednesday_of_month(date) - 2.days)
  end

  def self.third_wednesday_of_month(date)
    nth_wday(3, 3, date.month, date.year).to_date
  end

  # refrence: https://learning.oreilly.com/library/view/the-ruby-way/0768667208/0768667208_ch07lev1sec5.htm
  # rubocop:disable Style/AndOr, Metrics/MethodLength, Naming/MethodParameterName
  def self.nth_wday(n, wday, month, year)
    if (!n.between? 1, 5) or
       (!wday.between? 0, 6) or
       (!month.between? 1, 12)
      raise ArgumentError
    end

    t = Time.local year, month, 1
    first = t.wday
    if first == wday
      fwd = 1
    elsif first < wday
      fwd = wday - first + 1
    elsif first > wday
      fwd = (wday + 7) - first + 1
    end
    target = fwd + ((n - 1) * 7)
    begin
      t2 = Time.local year, month, target
    rescue ArgumentError
      return nil
    end
    t2 if t2.mday == target
  end
  # rubocop:enable Style/AndOr, Metrics/MethodLength, Naming/MethodParameterName
end
