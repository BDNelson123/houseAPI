class Zillow < ActiveRecord::Base
  belongs_to :user
  belongs_to :home

  @@zillow = 'X1-ZWz1b68wd3f6dn_2uji4'
  @@url = 'http://www.zillow.com/webservice'

  def self.format(param)
    if param.to_s.include? " "
      return param.gsub(' ','+')
    end
    return param
  end

  def self.Date(date)
    date = date.split("/")
    newDate = "#{date[2]}-#{date[0]}-#{date[1]}"
  end

  def self.exister(data)
    if data.present?
      return data.text
    end
    return nil
  end

  def self.check(params)
    return Nokogiri::XML(open("#{@@url}/GetDeepSearchResults.htm?zws-id=#{@@zillow}&address=#{format(params[:address])}+#{format(params[:address2])}&citystatezip=#{format(params[:city])}+#{format(params[:state])}+#{format(params[:zip])}").read).xpath("//message").xpath("code").text.to_i
  end

  def self.createNew(user_id, home_id, params)
    basic = Nokogiri::XML(open("#{@@url}/GetDeepSearchResults.htm?zws-id=#{@@zillow}&address=#{format(params[:address])}+#{format(params[:address2])}&citystatezip=#{format(params[:city])}+#{format(params[:state])}+#{format(params[:zip])}").read)
    graph_1 = Nokogiri::XML(open("#{@@url}/GetChart.htm?zws-id=#{@@zillow}&unit-type=dollar&zpid=#{basic.xpath("//result").xpath("zpid").text}&width=300&height=150&chartDuration=1year").read)
    graph_5 = Nokogiri::XML(open("#{@@url}/GetChart.htm?zws-id=#{@@zillow}&unit-type=dollar&zpid=#{basic.xpath("//result").xpath("zpid").text}&width=300&height=150&chartDuration=5years").read)
    related = Nokogiri::XML(open("#{@@url}/GetDeepComps.htm?zws-id=#{@@zillow}&zpid=#{basic.xpath("//result").xpath("zpid").text}&count=5").read)
    demographic = Nokogiri::XML(open("#{@@url}/GetDemographics.htm?zws-id=#{@@zillow}&regionid=#{basic.xpath("//localRealEstate").xpath("region").attr('id')}").read)

    create(
      "user_id" => user_id,
      "home_id" => home_id,
      "zpid" => self.exister(basic.xpath("//result").xpath("zpid")),
      "region_id" => self.exister(basic.xpath("//localRealEstate").xpath("region").attr('id')),
      "region_name" => self.exister(basic.xpath("//localRealEstate").xpath("region").attr('name')),
      "fipsCounty" => self.exister(basic.xpath("//FIPScounty")),
      "useCode" => self.exister(basic.xpath("//useCode")),
      "taxAssessmentYear" => self.exister(basic.xpath("//taxAssessmentYear")),
      "taxAssessment" => self.exister(basic.xpath("//taxAssessment")),
      "yearBuilt" => self.exister(basic.xpath("//yearBuilt")),
      "lotSizeSqFt" => self.exister(basic.xpath("//lotSizeSqFt")),
      "finishedSqFt" => self.exister(basic.xpath("//finishedSqFt")),
      "bathrooms" => self.exister(basic.xpath("//bathrooms")),
      "bedrooms" => self.exister(basic.xpath("//bedrooms")),
      "lastSoldDate" => self.Date(self.exister(basic.xpath("//lastSoldDate"))),
      "lastSoldPrice" => self.exister(basic.xpath("//lastSoldPrice")),
      "zestimate_amount" => self.exister(basic.xpath("//zestimate").xpath("amount")),
      "valuationRange_low" => self.exister(basic.xpath("//valuationRange").xpath("low")),
      "valuationRange_high" => self.exister(basic.xpath("//valuationRange").xpath("high")),
      "valuationGraph_1year" => self.exister(graph_1.xpath("//response").xpath("url")),
      "valuationGraph_5years" => self.exister(graph_5.xpath("//response").xpath("url")),
	    "related_0_zpid" => self.exister(related.xpath("//comp").xpath("zpid").children[0]),
	    "related_0_address" => self.exister(related.xpath("//comp").xpath("address").xpath("street").children[0]),
	    "related_0_city" => self.exister(related.xpath("//comp").xpath("address").xpath("city").children[0]),
	    "related_0_state" => self.exister(related.xpath("//comp").xpath("address").xpath("state").children[0]),
	    "related_0_zip" => self.exister(related.xpath("//comp").xpath("address").xpath("zipcode").children[0]),
	    "related_0_latitude" => self.exister(related.xpath("//comp").xpath("address").xpath("latitude").children[0]),
	    "related_0_longitude" => self.exister(related.xpath("//comp").xpath("address").xpath("longitude").children[0]),
	    "related_0_valuationRange_low" => self.exister(related.xpath("//comp").xpath("zestimate").xpath("valuationRange").xpath("low").children[0]),
	    "related_0_valuationRange_high" => self.exister(related.xpath("//comp").xpath("zestimate").xpath("valuationRange").xpath("high").children[0]),
	    "related_0_zestimate" => self.exister(related.xpath("//comp").xpath("zestimate").xpath("amount").children[0]),
	    "related_0_taxAssessmentYear" => self.exister(related.xpath("//comp").xpath("taxAssessmentYear").children[0]),
	    "related_0_taxAssessment" => self.exister(related.xpath("//comp").xpath("taxAssessment").children[0]),
	    "related_0_yearBuilt" => self.exister(related.xpath("//comp").xpath("yearBuilt").children[0]),
	    "related_0_lotSizeSqFt" => self.exister(related.xpath("//comp").xpath("lotSizeSqFt").children[0]),
	    "related_0_bathrooms" => self.exister(related.xpath("//comp").xpath("bathrooms").children[0]),
	    "related_0_bedrooms" => self.exister(related.xpath("//comp").xpath("bedrooms").children[0]),
	    "related_0_lastSoldDate" => self.Date(self.exister(related.xpath("//comp").xpath("lastSoldDate").children[0])),
	    "related_0_lastSoldPrice" => self.exister(related.xpath("//comp").xpath("lastSoldPrice").children[0]),
	    "related_1_zpid" => self.exister(related.xpath("//comp").xpath("zpid").children[1]),
	    "related_1_address" => self.exister(related.xpath("//comp").xpath("address").xpath("street").children[1]),
	    "related_1_city" => self.exister(related.xpath("//comp").xpath("address").xpath("city").children[1]),
	    "related_1_state" => self.exister(related.xpath("//comp").xpath("address").xpath("state").children[1]),
	    "related_1_zip" => self.exister(related.xpath("//comp").xpath("address").xpath("zipcode").children[1]),
	    "related_1_latitude" => self.exister(related.xpath("//comp").xpath("address").xpath("latitude").children[1]),
	    "related_1_longitude" => self.exister(related.xpath("//comp").xpath("address").xpath("longitude").children[1]),
	    "related_1_valuationRange_low" => self.exister(related.xpath("//comp").xpath("zestimate").xpath("valuationRange").xpath("low").children[1]),
	    "related_1_valuationRange_high" => self.exister(related.xpath("//comp").xpath("zestimate").xpath("valuationRange").xpath("high").children[1]),
	    "related_1_zestimate" => self.exister(related.xpath("//comp").xpath("zestimate").xpath("amount").children[1]),
	    "related_1_taxAssessmentYear" => self.exister(related.xpath("//comp").xpath("taxAssessmentYear").children[1]),
	    "related_1_taxAssessment" => self.exister(related.xpath("//comp").xpath("taxAssessment").children[1]),
	    "related_1_yearBuilt" => self.exister(related.xpath("//comp").xpath("yearBuilt").children[1]),
	    "related_1_lotSizeSqFt" => self.exister(related.xpath("//comp").xpath("lotSizeSqFt").children[1]),
	    "related_1_bathrooms" => self.exister(related.xpath("//comp").xpath("bathrooms").children[1]),
	    "related_1_bedrooms" => self.exister(related.xpath("//comp").xpath("bedrooms").children[1]),
	    "related_1_lastSoldDate" => self.Date(self.exister(related.xpath("//comp").xpath("lastSoldDate").children[1])),
	    "related_1_lastSoldPrice" => self.exister(related.xpath("//comp").xpath("lastSoldPrice").children[1]),
	    "related_2_zpid" => self.exister(related.xpath("//comp").xpath("zpid").children[2]),
	    "related_2_address" => self.exister(related.xpath("//comp").xpath("address").xpath("street").children[2]),
	    "related_2_city" => self.exister(related.xpath("//comp").xpath("address").xpath("city").children[2]),
	    "related_2_state" => self.exister(related.xpath("//comp").xpath("address").xpath("state").children[2]),
	    "related_2_zip" => self.exister(related.xpath("//comp").xpath("address").xpath("zipcode").children[2]),
	    "related_2_latitude" => self.exister(related.xpath("//comp").xpath("address").xpath("latitude").children[2]),
	    "related_2_longitude" => self.exister(related.xpath("//comp").xpath("address").xpath("longitude").children[2]),
	    "related_2_valuationRange_low" => self.exister(related.xpath("//comp").xpath("zestimate").xpath("valuationRange").xpath("low").children[2]),
	    "related_2_valuationRange_high" => self.exister(related.xpath("//comp").xpath("zestimate").xpath("valuationRange").xpath("high").children[2]),
	    "related_2_zestimate" => self.exister(related.xpath("//comp").xpath("zestimate").xpath("amount").children[2]),
	    "related_2_taxAssessmentYear" => self.exister(related.xpath("//comp").xpath("taxAssessmentYear").children[2]),
	    "related_2_taxAssessment" => self.exister(related.xpath("//comp").xpath("taxAssessment").children[2]),
	    "related_2_yearBuilt" => self.exister(related.xpath("//comp").xpath("yearBuilt").children[2]),
	    "related_2_lotSizeSqFt" => self.exister(related.xpath("//comp").xpath("lotSizeSqFt").children[2]),
	    "related_2_bathrooms" => self.exister(related.xpath("//comp").xpath("bathrooms").children[2]),
	    "related_2_bedrooms" => self.exister(related.xpath("//comp").xpath("bedrooms").children[2]),
	    "related_2_lastSoldDate" => self.Date(self.exister(related.xpath("//comp").xpath("lastSoldDate").children[2])),
	    "related_2_lastSoldPrice" => self.exister(related.xpath("//comp").xpath("lastSoldPrice").children[2]),
	    "demographics_medianCondoValue" => self.exister(demographic.xpath("//charts").xpath("chart").xpath("url").children[0]),
	    "demographics_medianHomeValue" => self.exister(demographic.xpath("//charts").xpath("chart").xpath("url").children[1]),
	    "demographics_dollarsPerSquareFeet" => self.exister(demographic.xpath("//charts").xpath("chart").xpath("url").children[2]),
	    "demographics_zillowHomeValueIndexDistribution" => self.exister(demographic.xpath("//charts").xpath("chart").xpath("url").children[3]),
	    "demographics_homeType" => self.exister(demographic.xpath("//charts").xpath("chart").xpath("url").children[4]),
	    "demographics_ownersVsRenters" => self.exister(demographic.xpath("//charts").xpath("chart").xpath("url").children[5]),
	    "demographics_homeSizeInSquareFeet" => self.exister(demographic.xpath("//charts").xpath("chart").xpath("url").children[6]),
	    "demographics_yearBuilt" => self.exister(demographic.xpath("//charts").xpath("chart").xpath("url").children[7]),
	    "demographics_zillowHomeValueIndex" => self.exister(demographic.xpath("//pages//attribute//name[text()='Zillow Home Value Index']/following-sibling::values/city/value")),
	    "demographics_medianSingleFamilyHomeValue" => self.exister(demographic.xpath("//pages//attribute//name[text()='Median Single Family Home Value']/following-sibling::values/city/value")),
	    "demographics_medianCondoValueAmount" => self.exister(demographic.xpath("//pages//attribute//name[text()='Median Condo Value']/following-sibling::values/city/value")),
	    "demographics_median2BedroomHomeValue" => self.exister(demographic.xpath("//pages//attribute//name[text()='Median 2-Bedroom Home Value']/following-sibling::values/city/value")),
	    "demographics_median3BedroomHomeValue" => self.exister(demographic.xpath("//pages//attribute//name[text()='Median 3-Bedroom Home Value']/following-sibling::values/city/value")),
	    "demographics_median4BedroomHomeValue" => self.exister(demographic.xpath("//pages//attribute//name[text()='Median 4-Bedroom Home Value']/following-sibling::values/city/value")),
	    "demographics_percentHomesDecreasing" => self.exister(demographic.xpath("//pages//attribute//name[text()='Percent Homes Decreasing']/following-sibling::values/city/value")),
	    "demographics_percentListingPriceReduction" => self.exister(demographic.xpath("//pages//attribute//name[text()='Percent Listing Price Reduction']/following-sibling::values/city/value")),
	    "demographics_medianListPricePerSqFt" => self.exister(demographic.xpath("//pages//attribute//name[text()='Median List Price Per Sq Ft']/following-sibling::values/city/value")),
	    "demographics_medianListPrice" => self.exister(demographic.xpath("//pages//attribute//name[text()='Median List Price']/following-sibling::values/city/value")),
	    "demographics_medianSalePrice" => self.exister(demographic.xpath("//pages//attribute//name[text()='Median Sale Price']/following-sibling::values/city/value")),
	    "demographics_medianValuePerSqFt" => self.exister(demographic.xpath("//pages//attribute//name[text()='Median Value Per Sq Ft']/following-sibling::values/city/value")),
	    "demographics_propertyTax" => self.exister(demographic.xpath("//pages//attribute//name[text()='Property Tax']/following-sibling::values/city/value"))
    )
  end
end
