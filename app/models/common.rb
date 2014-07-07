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
      if date.text == ''
        return nil
      else
        date = date.text.split("/")
        return "#{date[2]}-#{date[0]}-#{date[1]}"
      end
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

  # model: images
  # purpose: returns the correct foreign_key attribute for who owns the image
  def self.klass(klass)
    if klass == 'home'
      return :home_id
    elsif klass == 'user'
      return :user_id
    end
  end

  # model: images
  # purpose: returns the correct foreign_key id for who owns the image
  def self.klass_id(params,token_from_id)
    if params[:klass] == 'home'
      return params[:home_id]
    elsif params[:klass] == 'user'
      return token_from_id
    end
  end

  # model: homes
  # purpose: returns the user id from token if user_id is not present
  def self.home_user(params,token_from_id)
    if params
      return params
    else
      return token_from_id
    end
  end
end
