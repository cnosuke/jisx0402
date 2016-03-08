require 'spec_helper'

describe Jisx0402 do
  before { Jisx0402.warmup }

  it "has a version number" do
    expect(Jisx0402::VERSION).not_to be nil
  end

  let(:shibuya_code) { "131130" }

  it ".search('東京都渋谷区')" do
    expect(Jisx0402.search("東京都渋谷区").code).to eq(shibuya_code)
  end

  it ".forward_match_by_full(東京都渋谷区)" do
    expect(Jisx0402.forward_match_by_full("東京都渋谷区").first.code).to eq(shibuya_code)
  end

  it ".forward_match_by_code('131130')" do
    expect(Jisx0402.forward_match_by_code("131130").first.code).to eq(shibuya_code)
  end

  it ".forward_match_by_code('13')" do
    expect(Jisx0402.forward_match_by_code("13").zipcodes.size).to eq(3805)
    expect(Jisx0402.forward_match_by_code("13").map(&:prefecture).uniq).to eq(['東京都'])
  end

  it ".search('渋谷区')" do
    expect(Jisx0402.search('渋谷区').code).to eq(shibuya_code)
  end

  it ".search('しぶや')" do
    expect(Jisx0402.search('しぶや').code).to eq(shibuya_code)
  end

  it ".search('しぶや').code_without_checkdigit" do
    expect(Jisx0402.search('しぶや').code_without_checkdigit).to eq(shibuya_code[0..-2])
  end

  it ".search('渋谷区').zipcodes" do
    expect(Jisx0402.search('渋谷区').zipcodes).to eq(
      [
        "1500000", "1510064", "1500032", "1500042", "1500013", "1506090",
        "1506001", "1506002", "1506003", "1506004", "1506005", "1506006",
        "1506007", "1506008", "1506009", "1506010", "1506011", "1506012",
        "1506013", "1506014", "1506015", "1506016", "1506017", "1506018",
        "1506019", "1506020", "1506021", "1506022", "1506023", "1506024",
        "1506025", "1506026", "1506027", "1506028", "1506029", "1506030",
        "1506031", "1506032", "1506033", "1506034", "1506035", "1506036",
        "1506037", "1506038", "1506039", "1500021", "1500022", "1510065",
        "1500047", "1500031", "1510073", "1500033", "1500002", "1500046",
        "1500001", "1500045", "1500041", "1510051", "1500034", "1500043",
        "1510063", "1500036", "1510066", "1510072", "1500035", "1510061",
        "1500011", "1500012", "1510071", "1500044", "1510062", "1510053",
        "1510052",
      ]
    )
  end

  it ".search('東京都').zipcodes" do
    expect(Jisx0402.search('東京都').zipcodes.size).to eq(3805)
  end

  it ".match_by_zipcode" do
    expect(Jisx0402.match_by_zipcode('1506012').code).to eq('131130')
    expect(Jisx0402.match_by_zipcode('1506022').code).to eq('131130')
    expect(Jisx0402.match_by_zipcode('1500033').code).to eq('131130')
    expect(Jisx0402.match_by_zipcode('1500044').code).to eq('131130')
  end
end
