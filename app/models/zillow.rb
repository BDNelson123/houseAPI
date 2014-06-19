class Zillow < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  belongs_to :home, dependent: :destroy

  @@zillow = 'X1-ZWz1b68wd3f6dn_2uji4'
  @@url = 'http://www.zillow.com/webservice'

  def self.check(params)
    return Nokogiri::XML(open("#{@@url}/GetDeepSearchResults.htm?zws-id=#{@@zillow}&address=#{Common.format(params[:address])}+#{Common.format(params[:address2])}&citystatezip=#{Common.format(params[:city])}+#{Common.format(params[:state])}+#{Common.format(params[:zip])}").read).xpath("//message").xpath("code").text.to_i
  end

  def self.createNew(user_id, home_id, params)
    basic = Nokogiri::XML(open("#{@@url}/GetDeepSearchResults.htm?zws-id=#{@@zillow}&address=#{Common.format(params[:address])}+#{Common.format(params[:address2])}&citystatezip=#{Common.format(params[:city])}+#{Common.format(params[:state])}+#{Common.format(params[:zip])}").read)
    graph_1 = Nokogiri::XML(open("#{@@url}/GetChart.htm?zws-id=#{@@zillow}&unit-type=dollar&zpid=#{basic.xpath("//result").xpath("zpid").text}&width=300&height=150&chartDuration=1year").read)
    graph_5 = Nokogiri::XML(open("#{@@url}/GetChart.htm?zws-id=#{@@zillow}&unit-type=dollar&zpid=#{basic.xpath("//result").xpath("zpid").text}&width=300&height=150&chartDuration=5years").read)
    related = Nokogiri::XML(open("#{@@url}/GetDeepComps.htm?zws-id=#{@@zillow}&zpid=#{basic.xpath("//result").xpath("zpid").text}&count=5").read)
    demographic = Nokogiri::XML(open("#{@@url}/GetDemographics.htm?zws-id=#{@@zillow}&regionid=#{basic.xpath("//localRealEstate").xpath("region").attr('id')}").read)

    create(
      "user_id" => user_id,
      "home_id" => home_id,
      "zpid" => Common.exister(basic.xpath("//result").xpath("zpid")),
      "region_id" => Common.exister(basic.xpath("//localRealEstate").xpath("region").attr('id')),
      "region_name" => Common.exister(basic.xpath("//localRealEstate").xpath("region").attr('name')),
      "fipsCounty" => Common.exister(basic.xpath("//FIPScounty")),
      "useCode" => Common.exister(basic.xpath("//useCode")),
      "taxAssessmentYear" => Common.exister(basic.xpath("//taxAssessmentYear")),
      "taxAssessment" => Common.exister(basic.xpath("//taxAssessment")),
      "yearBuilt" => Common.exister(basic.xpath("//yearBuilt")),
      "lotSizeSqFt" => Common.exister(basic.xpath("//lotSizeSqFt")),
      "finishedSqFt" => Common.exister(basic.xpath("//finishedSqFt")),
      "bathrooms" => Common.exister(basic.xpath("//bathrooms")),
      "bedrooms" => Common.exister(basic.xpath("//bedrooms")),
      "lastSoldDate" => Common.date(basic.xpath("//lastSoldDate")),
      "lastSoldPrice" => Common.exister(basic.xpath("//lastSoldPrice")),
      "zestimate_amount" => Common.exister(basic.xpath("//zestimate").xpath("amount")),
      "valuationRange_low" => Common.exister(basic.xpath("//valuationRange").xpath("low")),
      "valuationRange_high" => Common.exister(basic.xpath("//valuationRange").xpath("high")),
      "valuationGraph_1year" => Common.exister(graph_1.xpath("//response").xpath("url")),
      "valuationGraph_5years" => Common.exister(graph_5.xpath("//response").xpath("url")),
	    "related_0_zpid" => Common.exister(related.xpath("//comp").xpath("zpid").children[0]),
	    "related_0_address" => Common.exister(related.xpath("//comp").xpath("address").xpath("street").children[0]),
	    "related_0_city" => Common.exister(related.xpath("//comp").xpath("address").xpath("city").children[0]),
	    "related_0_state" => Common.exister(related.xpath("//comp").xpath("address").xpath("state").children[0]),
	    "related_0_zip" => Common.exister(related.xpath("//comp").xpath("address").xpath("zipcode").children[0]),
	    "related_0_latitude" => Common.exister(related.xpath("//comp").xpath("address").xpath("latitude").children[0]),
	    "related_0_longitude" => Common.exister(related.xpath("//comp").xpath("address").xpath("longitude").children[0]),
	    "related_0_valuationRange_low" => Common.exister(related.xpath("//comp").xpath("zestimate").xpath("valuationRange").xpath("low").children[0]),
	    "related_0_valuationRange_high" => Common.exister(related.xpath("//comp").xpath("zestimate").xpath("valuationRange").xpath("high").children[0]),
	    "related_0_zestimate" => Common.exister(related.xpath("//comp").xpath("zestimate").xpath("amount").children[0]),
	    "related_0_taxAssessmentYear" => Common.exister(related.xpath("//comp").xpath("taxAssessmentYear").children[0]),
	    "related_0_taxAssessment" => Common.exister(related.xpath("//comp").xpath("taxAssessment").children[0]),
	    "related_0_yearBuilt" => Common.exister(related.xpath("//comp").xpath("yearBuilt").children[0]),
	    "related_0_lotSizeSqFt" => Common.exister(related.xpath("//comp").xpath("lotSizeSqFt").children[0]),
	    "related_0_bathrooms" => Common.exister(related.xpath("//comp").xpath("bathrooms").children[0]),
	    "related_0_bedrooms" => Common.exister(related.xpath("//comp").xpath("bedrooms").children[0]),
	    "related_0_lastSoldDate" => Common.date(related.xpath("//comp").xpath("lastSoldDate").children[0]),
	    "related_0_lastSoldPrice" => Common.exister(related.xpath("//comp").xpath("lastSoldPrice").children[0]),
	    "related_1_zpid" => Common.exister(related.xpath("//comp").xpath("zpid").children[1]),
	    "related_1_address" => Common.exister(related.xpath("//comp").xpath("address").xpath("street").children[1]),
	    "related_1_city" => Common.exister(related.xpath("//comp").xpath("address").xpath("city").children[1]),
	    "related_1_state" => Common.exister(related.xpath("//comp").xpath("address").xpath("state").children[1]),
	    "related_1_zip" => Common.exister(related.xpath("//comp").xpath("address").xpath("zipcode").children[1]),
	    "related_1_latitude" => Common.exister(related.xpath("//comp").xpath("address").xpath("latitude").children[1]),
	    "related_1_longitude" => Common.exister(related.xpath("//comp").xpath("address").xpath("longitude").children[1]),
	    "related_1_valuationRange_low" => Common.exister(related.xpath("//comp").xpath("zestimate").xpath("valuationRange").xpath("low").children[1]),
	    "related_1_valuationRange_high" => Common.exister(related.xpath("//comp").xpath("zestimate").xpath("valuationRange").xpath("high").children[1]),
	    "related_1_zestimate" => Common.exister(related.xpath("//comp").xpath("zestimate").xpath("amount").children[1]),
	    "related_1_taxAssessmentYear" => Common.exister(related.xpath("//comp").xpath("taxAssessmentYear").children[1]),
	    "related_1_taxAssessment" => Common.exister(related.xpath("//comp").xpath("taxAssessment").children[1]),
	    "related_1_yearBuilt" => Common.exister(related.xpath("//comp").xpath("yearBuilt").children[1]),
	    "related_1_lotSizeSqFt" => Common.exister(related.xpath("//comp").xpath("lotSizeSqFt").children[1]),
	    "related_1_bathrooms" => Common.exister(related.xpath("//comp").xpath("bathrooms").children[1]),
	    "related_1_bedrooms" => Common.exister(related.xpath("//comp").xpath("bedrooms").children[1]),
	    "related_1_lastSoldDate" => Common.date(related.xpath("//comp").xpath("lastSoldDate").children[1]),
	    "related_1_lastSoldPrice" => Common.exister(related.xpath("//comp").xpath("lastSoldPrice").children[1]),
	    "related_2_zpid" => Common.exister(related.xpath("//comp").xpath("zpid").children[2]),
	    "related_2_address" => Common.exister(related.xpath("//comp").xpath("address").xpath("street").children[2]),
	    "related_2_city" => Common.exister(related.xpath("//comp").xpath("address").xpath("city").children[2]),
	    "related_2_state" => Common.exister(related.xpath("//comp").xpath("address").xpath("state").children[2]),
	    "related_2_zip" => Common.exister(related.xpath("//comp").xpath("address").xpath("zipcode").children[2]),
	    "related_2_latitude" => Common.exister(related.xpath("//comp").xpath("address").xpath("latitude").children[2]),
	    "related_2_longitude" => Common.exister(related.xpath("//comp").xpath("address").xpath("longitude").children[2]),
	    "related_2_valuationRange_low" => Common.exister(related.xpath("//comp").xpath("zestimate").xpath("valuationRange").xpath("low").children[2]),
	    "related_2_valuationRange_high" => Common.exister(related.xpath("//comp").xpath("zestimate").xpath("valuationRange").xpath("high").children[2]),
	    "related_2_zestimate" => Common.exister(related.xpath("//comp").xpath("zestimate").xpath("amount").children[2]),
	    "related_2_taxAssessmentYear" => Common.exister(related.xpath("//comp").xpath("taxAssessmentYear").children[2]),
	    "related_2_taxAssessment" => Common.exister(related.xpath("//comp").xpath("taxAssessment").children[2]),
	    "related_2_yearBuilt" => Common.exister(related.xpath("//comp").xpath("yearBuilt").children[2]),
	    "related_2_lotSizeSqFt" => Common.exister(related.xpath("//comp").xpath("lotSizeSqFt").children[2]),
	    "related_2_bathrooms" => Common.exister(related.xpath("//comp").xpath("bathrooms").children[2]),
	    "related_2_bedrooms" => Common.exister(related.xpath("//comp").xpath("bedrooms").children[2]),
	    "related_2_lastSoldDate" => Common.date(related.xpath("//comp").xpath("lastSoldDate").children[2]),
	    "related_2_lastSoldPrice" => Common.exister(related.xpath("//comp").xpath("lastSoldPrice").children[2]),
	    "demographics_medianCondoValue" => Common.exister(demographic.xpath("//charts").xpath("chart").xpath("url").children[0]),
	    "demographics_medianHomeValue" => Common.exister(demographic.xpath("//charts").xpath("chart").xpath("url").children[1]),
	    "demographics_dollarsPerSquareFeet" => Common.exister(demographic.xpath("//charts").xpath("chart").xpath("url").children[2]),
	    "demographics_zillowHomeValueIndexDistribution" => Common.exister(demographic.xpath("//charts").xpath("chart").xpath("url").children[3]),
	    "demographics_homeType" => Common.exister(demographic.xpath("//charts").xpath("chart").xpath("url").children[4]),
	    "demographics_ownersVsRenters" => Common.exister(demographic.xpath("//charts").xpath("chart").xpath("url").children[5]),
	    "demographics_homeSizeInSquareFeet" => Common.exister(demographic.xpath("//charts").xpath("chart").xpath("url").children[6]),
	    "demographics_yearBuilt" => Common.exister(demographic.xpath("//charts").xpath("chart").xpath("url").children[7]),
	    "demographics_zillowHomeValueIndex" => Common.exister(demographic.xpath("//pages//attribute//name[text()='Zillow Home Value Index']/following-sibling::values/city/value")),
	    "demographics_medianSingleFamilyHomeValue" => Common.exister(demographic.xpath("//pages//attribute//name[text()='Median Single Family Home Value']/following-sibling::values/city/value")),
	    "demographics_medianCondoValueAmount" => Common.exister(demographic.xpath("//pages//attribute//name[text()='Median Condo Value']/following-sibling::values/city/value")),
	    "demographics_median2BedroomHomeValue" => Common.exister(demographic.xpath("//pages//attribute//name[text()='Median 2-Bedroom Home Value']/following-sibling::values/city/value")),
	    "demographics_median3BedroomHomeValue" => Common.exister(demographic.xpath("//pages//attribute//name[text()='Median 3-Bedroom Home Value']/following-sibling::values/city/value")),
	    "demographics_median4BedroomHomeValue" => Common.exister(demographic.xpath("//pages//attribute//name[text()='Median 4-Bedroom Home Value']/following-sibling::values/city/value")),
	    "demographics_percentHomesDecreasing" => Common.exister(demographic.xpath("//pages//attribute//name[text()='Percent Homes Decreasing']/following-sibling::values/city/value")),
	    "demographics_percentListingPriceReduction" => Common.exister(demographic.xpath("//pages//attribute//name[text()='Percent Listing Price Reduction']/following-sibling::values/city/value")),
	    "demographics_medianListPricePerSqFt" => Common.exister(demographic.xpath("//pages//attribute//name[text()='Median List Price Per Sq Ft']/following-sibling::values/city/value")),
	    "demographics_medianListPrice" => Common.exister(demographic.xpath("//pages//attribute//name[text()='Median List Price']/following-sibling::values/city/value")),
	    "demographics_medianSalePrice" => Common.exister(demographic.xpath("//pages//attribute//name[text()='Median Sale Price']/following-sibling::values/city/value")),
	    "demographics_medianValuePerSqFt" => Common.exister(demographic.xpath("//pages//attribute//name[text()='Median Value Per Sq Ft']/following-sibling::values/city/value")),
	    "demographics_propertyTax" => Common.exister(demographic.xpath("//pages//attribute//name[text()='Property Tax']/following-sibling::values/city/value"))
    )
  end
end
