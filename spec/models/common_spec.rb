require 'spec_helper'

describe Common do
  describe "format" do
    it "should replace spaces with addition signs" do
      phrase = Common.format("I love to play basketball")
      expect(phrase).to eq("I+love+to+play+basketball")
    end

    it "should return the phrase" do
      phrase = Common.format("ILoveToPlayBasketball")
      expect(phrase).to eq("ILoveToPlayBasketball")
    end

    it "should return the phrase" do
      phrase = Common.format("I_Love_To_Play_Basketball")
      expect(phrase).to eq("I_Love_To_Play_Basketball")
    end
  end

  describe "date" do
    it "should return date in the format of year-month-date" do
      doc = Nokogiri::XML(open("#{Rails.root}/spec/samples/GetZestimate.xml").read)
      last_updated = doc.xpath("//zestimate").xpath("last-updated")
      date = Common.date(last_updated)
      expect(date).to eq("2014-06-24")
    end

    it "should return nil if no date is present" do
      doc = Nokogiri::XML(open("#{Rails.root}/spec/samples/GetZestimate.xml").read)
      last_updated = doc.xpath("//zestimate").xpath("last-updated-completely-empty")
      date = Common.date(last_updated)
      expect(date).to eq(nil)
    end

    it "should return nil if date is empty" do
      doc = Nokogiri::XML(open("#{Rails.root}/spec/samples/GetZestimate.xml").read)
      last_updated = doc.xpath("//zestimate").xpath("last-updated-empty")
      date = Common.date(last_updated)
      expect(date).to eq(nil)
    end
  end

  describe "exister" do
    it "should return the field if field is not empty" do
      doc = Nokogiri::XML(open("#{Rails.root}/spec/samples/GetZestimate.xml").read)
      amount = doc.xpath("//zestimate").xpath("amount")
      field = Common.exister(amount)
      expect(field).to eq(amount.text)
    end

    it "should return nil if field is empty" do
      doc = Nokogiri::XML(open("#{Rails.root}/spec/samples/GetZestimate.xml").read)
      last_updated = doc.xpath("//zestimate").xpath("last-updated-completely-empty")
      field = Common.exister(last_updated)
      expect(field).to eq(nil)
    end
  end

  describe "klass" do
    it "should return home_id when attribute is home" do
      var = Common.klass("home")
      expect(var).to eq(:home_id)
    end
  end

  describe "klass" do
    it "should return user_id when attribute is user" do
      var = Common.klass("user")
      expect(var).to eq(:user_id)
    end
  end
end
