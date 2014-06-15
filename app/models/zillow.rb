class Zillow < ActiveRecord::Base
  belongs_to :user
  belongs_to :home

  def self.format(param)
    if param.to_s.include? " "
      return param.gsub(' ','+')
    else
      return param
    end
  end

  def self.Date(date)
    date = date.split("/")
    newDate = "#{date[2]}-#{date[0]}-#{date[1]}"
  end

  def self.createNew(user_id, home_id, params)
    doc = Nokogiri::XML(open("http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=X1-ZWz1b68wd3f6dn_2uji4&address=#{format(params[:address])}+#{format(params[:address2])}&citystatezip=#{format(params[:city])}+#{format(params[:state])}+#{format(params[:zip])}").read)

    create(
      "user_id" => user_id,
      "home_id" => home_id,
      "zpid" => doc.xpath("//result").xpath("zpid").text,
      "FIPScounty" => doc.xpath("//FIPScounty").text,
      "useCode" => doc.xpath("//useCode").text,
      "taxAssessmentYear" => doc.xpath("//taxAssessmentYear").text,
      "taxAssessment" => doc.xpath("//taxAssessment").text,
      "yearBuilt" => doc.xpath("//yearBuilt").text,
      "lotSizeSqFt" => doc.xpath("//lotSizeSqFt").text,
      "finishedSqFt" => doc.xpath("//finishedSqFt").text,
      "bathrooms" => doc.xpath("//bathrooms").text,
      "bedrooms" => doc.xpath("//bedrooms").text,
      "lastSoldDate" => self.Date(doc.xpath("//lastSoldDate").text),
      "lastSoldPrice" => doc.xpath("//lastSoldPrice").text,
      "zestimate_amount" => doc.xpath("//zestimate").xpath("amount").text,
      "valuationRange_low" => doc.xpath("//valuationRange").xpath("low").text,
      "valuationRange_high" => doc.xpath("//valuationRange").xpath("high").text
    )
  end

  def self.check(params)
    return Nokogiri::XML(open("http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=X1-ZWz1b68wd3f6dn_2uji4&address=#{format(params[:address])}+#{format(params[:address2])}&citystatezip=#{format(params[:city])}+#{format(params[:state])}+#{format(params[:zip])}").read).xpath("//message").xpath("code").text.to_i
  end
end
