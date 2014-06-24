class Home < ActiveRecord::Base
  belongs_to :user
  has_many :images
  has_many :bids

  validates :address, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true
  validates :zip, :presence => true
  validates :zip, numericality: { only_integer: true }
  validates :price, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than => 0}

  scope :home_attributes, -> { select('
    homes.*, "zpid", "fipsCounty", "useCode", "taxAssessmentYear", "taxAssessment", 
    "yearBuilt", "lotSizeSqFt", "finishedSqFt", "bathrooms", "bedrooms", "lastSoldDate", "lastSoldPrice", "zestimate_amount", 
    "valuationRange_low", "valuationRange_high", "related_0_zpid","related_0_address","related_0_city","related_0_state","related_0_zip","related_0_latitude",
    "related_0_longitude","related_0_valuationRange_low","related_0_valuationRange_high","related_0_zestimate",
    "related_0_taxAssessmentYear","related_0_taxAssessment","related_0_yearBuilt","related_0_lotSizeSqFt",
    "related_0_bathrooms","related_0_bedrooms","related_0_lastSoldDate","related_0_lastSoldPrice","related_1_zpid",
    "related_1_address","related_1_city","related_1_state","related_1_zip","related_1_latitude","related_1_longitude",
    "related_1_valuationRange_low","related_1_valuationRange_high","related_1_zestimate","related_1_taxAssessmentYear",
    "related_1_taxAssessment","related_1_yearBuilt","related_1_lotSizeSqFt","related_1_bathrooms","related_1_bedrooms",
    "related_1_lastSoldDate","related_1_lastSoldPrice","related_2_zpid","related_2_address","related_2_city","related_2_state",
    "related_2_zip","related_2_latitude","related_2_longitude","related_2_valuationRange_low","related_2_valuationRange_high",
    "related_2_zestimate","related_2_taxAssessmentYear","related_2_taxAssessment","related_2_yearBuilt",
    "region_id","region_name","related_2_lotSizeSqFt","related_2_bathrooms","related_2_bedrooms","related_2_lastSoldDate",
    "related_2_lastSoldPrice","valuationGraph_1year","valuationGraph_5years",
    "demographics_medianCondoValue","demographics_medianHomeValue","demographics_dollarsPerSquareFeet",
    "demographics_zillowHomeValueIndexDistribution","demographics_homeType","demographics_ownersVsRenters",
    "demographics_homeSizeInSquareFeet","demographics_yearBuilt","demographics_zillowHomeValueIndex",
    "demographics_medianSingleFamilyHomeValue","demographics_medianCondoValueAmount","demographics_median2BedroomHomeValue",
    "demographics_median3BedroomHomeValue","demographics_median4BedroomHomeValue","demographics_percentHomesDecreasing",
    "demographics_percentListingPriceReduction","demographics_medianListPricePerSqFt","demographics_medianListPrice",
    "demographics_medianSalePrice","demographics_medianValuePerSqFt","demographics_propertyTax",
    array_agg(images.image) AS images') 
  }
  scope :home_joins, -> { joins("LEFT JOIN images ON images.home_id = homes.id JOIN zillows ON zillows.home_id = homes.id") }
end
