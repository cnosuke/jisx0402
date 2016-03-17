require 'spec_helper'

describe Jisx0402 do
  before { Jisx0402.warmup }

  it "has a version number" do
    expect(Jisx0402::VERSION).not_to be nil
  end

  let(:shibuya_code) { "131130" }
  let(:tokyo_code) { "13" }

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
    expect(Jisx0402.forward_match_by_code(tokyo_code).zipcodes.size).to eq(3805)
    expect(Jisx0402.forward_match_by_code(tokyo_code).map(&:prefecture).uniq).to eq(['東京都'])
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

  describe ".find_by_code" do
    let(:code) { '' }
    subject do
      Jisx0402.find_by_code(code)
    end

    context "131130 is 渋谷区" do
      let(:code) { '131130' }
      it { expect(subject).to eq(Jisx0402.forward_match_by_code(code).first)}
    end

    context "13113(w/o checkdigit) is 渋谷区" do
      let(:code) { '13113' }
      it { expect(subject).to eq(Jisx0402.forward_match_by_code('131130').first)}
    end

    context "13 is 東京都" do
      let(:code) { '13' }
      it { expect(subject).to eq(Jisx0402.forward_match_by_code(code).first)}
      it { expect(subject.prefecture?).to be_truthy }
    end

    context "130001 is also 東京都" do
      let(:code) { '130001' }
      it { expect(subject).to eq(Jisx0402.forward_match_by_code(code).first)}
      it { expect(subject.prefecture?).to be_truthy }
    end
  end

  describe "#prefecture?" do
    let(:area) { '' }
    subject do
      Jisx0402.forward_match_by_full(area).first.prefecture?
    end

    context "東京都 is a pref." do
      let(:area) { '東京都' }
      it { expect(subject).to be_truthy }
    end

    context "富山県 is a pref." do
      let(:area) { '富山県' }
      it { expect(subject).to be_truthy }
    end

    context "渋谷区 isn't a pref." do
      let(:area) { '東京都渋谷区' }
      it { expect(subject).to be_falsey }
    end
  end

  describe "#ward?" do
    let(:area) { '' }
    subject do
      Jisx0402.forward_match_by_full(area).first.ward?
    end

    context "渋谷区 is a ward" do
      let(:area) { "東京都渋谷区" }
      it { expect(subject).to be_truthy }
    end

    context "つくば市 isn't a ward" do
      let(:area) { "茨城県つくば市" }
      it { expect(subject).to be_falsey }
    end
  end

  describe '#government_ordinance_designated_city?' do
    let(:cities) do
      %w(
        札幌市 仙台市 さいたま市 千葉市 横浜市 川崎市 相模原市 新潟市 静岡市 浜松市
        名古屋市 京都市 大阪市 堺市 神戸市 岡山市 広島市 北九州市 福岡市 熊本市
      )
    end
    it do
      expect(
        Jisx0402.data.select { |d| d.government_ordinance_designated_city? }.
          map { |d| d.district }.sort
      ).to eq(cities.sort)
    end
  end

  describe '#cover?' do
    let(:kanagawa_pref_code) { '14' } # 神奈川県
    let(:yokohama_city_code) { '141003' } # 神奈川県横浜市
    let(:tsurumi_ward_code) { '141011' } # 神奈川県横浜市鶴見区
    let(:kawasaki_city_code) { '141305' } # 神奈川県川崎市
    let(:kawasaki_ward_code) { '141313' } # 神奈川県川崎市川崎区
    let(:area) { '' }
    let(:target) { '' }

    subject do
      Jisx0402.forward_match_by_code(area).first
    end

    context '鶴見区 and 川崎市 is a part of 神奈川県' do
      let(:area) { kanagawa_pref_code }
      it { expect(subject.cover?(tsurumi_ward_code)).to be_truthy }
      it { expect(subject.cover?(kawasaki_city_code)).to be_truthy }
      it { expect(subject.cover?(shibuya_code)).to be_falsey }
    end

    context '鶴見区 is a part of 横浜市, but 川崎区 is not.' do
      let(:area) { yokohama_city_code }
      it { expect(subject.cover?(tsurumi_ward_code)).to be_truthy }
      it { expect(subject.cover?(kawasaki_ward_code)).to be_falsey }
      it { expect(subject.cover?(shibuya_code)).to be_falsey }
    end

    context '川崎市 is not a part of 横浜市' do
      let(:area) { yokohama_city_code }
      it { expect(subject.cover?(kawasaki_city_code)).to be_falsey }
    end

    context '鶴見区 covers 鶴見区 but 川崎区' do
      let(:area) { tsurumi_ward_code }
      it { expect(subject.cover?(tsurumi_ward_code)).to be_truthy }
      it { expect(subject.cover?(kawasaki_ward_code)).to be_falsey }
    end
  end
end
