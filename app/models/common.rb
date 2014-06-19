class Common
  # model: zillows
  # purpose: formats house info for zillow API to understand
  def self.format(param)
    if param.to_s.include? " "
      return param.gsub(' ','+')
    end
    return param
  end

  # model: zillows
  # purpose: zillow sends date as month/day/year, we need it is as year-month-day
  def self.date(date)
    if date.present?
      date = date.text.split("/")
      return "#{date[2]}-#{date[0]}-#{date[1]}"
    end
    return nil
  end

  # model: zillows
  # purpose: return nil if data doesn't exist
  def self.exister(data)
    if data.present?
      return data.text
    end
    return nil
  end
end