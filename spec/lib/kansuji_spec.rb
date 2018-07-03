require "spec_helper"
require 'kansuji'
#TODO: TDD
RSpec.describe "Convert number to kanji and opposite: " do
  let(:s_num) { { '零' => 0, '一' => 1, '二' => 2, '三' => 3, '四' => 4,'五' => 5, '六' => 6, '七' => 7, '八' => 8, '九' => 9 } }
  let(:m_num) { { '十' => 10, '百' => 100, '千' => 1000 } }
  let(:l_num) { { '万' => 10**4, '億' => 10**8, '兆' => 10**12, '京' => 10**16, '垓' => 10**20, '𥝱' => 10**24, 
                  '穣' => 10**28, '溝' => 10**32, '澗' => 10**36, '正' => 10**40, '載' => 10**44, '極' => 10**48, 
                  '恒河沙' => 10**52, '阿僧祇' => 10**56, '那由他' => 10**60, '不可思議' => 10**64, '無量大数' => 10**68 } }
                  
  it "Check to_kansuji function" do
    expect{ 1212.212.to_kansuji }.to raise_error(NoMethodError)
    expect{ 十二.to_kansuji }.to raise_error(NameError)
    expect{ "1234".to_kansuji }.to raise_error(NoMethodError)
    expect{ ["1234"].to_kansuji }.to raise_error(NoMethodError)
    expect(11.to_kansuji).to eq "十一"
    expect(469.to_kansuji).to eq "四百六十九"
    expect(2025.to_kansuji).to eq "二千二十五"
    expect(510000087621686252440100002073.to_kansuji).to eq "五十一穣八百七十六垓二千百六十八京六千二百五十二兆四千四百一億二千七十三"
    expect(123456789012345678901234567890.to_kansuji).to eq "十二穣三千四百五十六𥝱七千八百九十垓千二百三十四京五千六百七十八兆九千十二億三千四百五十六万七千八百九十"
    s_num.each { |key, value| expect(value.to_kansuji).to eq key }
    m_num.each { |key, value| expect(value.to_kansuji).to eq key }
    l_num.each { |key, value| expect(value.to_kansuji).to eq "一#{key}" }
  end

  it "Check to_number function" do
    expect{ 1212.to_number }.to raise_error(NoMethodError)
    expect{ 十二.to_number }.to raise_error(NameError)
    expect{ ["十二"].to_number }.to raise_error(NoMethodError)
    expect("".to_number).to eq 0
    expect("1212".to_number).to eq 0
    expect("45十21二67".to_number).to eq 12
    expect("四    百六    十九".to_number).to eq 469
    expect("十二".to_number).to eq 12
    expect("四百六十九".to_number).to eq 469
    expect("五十一穣八百七十六垓二千百六十八京六千二百五十二兆四千四百一億二千七十三".to_number).to eq 510000087621686252440100002073
    expect("十二穣三千四百五十六𥝱七千八百九十垓千二百三十四京五千六百七十八兆九千十二億三千四百五十六万七千八百九十".to_number).to eq 123456789012345678901234567890
    s_num.each { |key, value| expect(key.to_number).to eq value }
    m_num.each { |key, value| expect(key.to_number).to eq value }
    l_num.each { |key, value| expect("一#{key}".to_number).to eq value  }
  end

  it "Check to_number and to_kansuji functions together" do
    10000.times do 
      number_random = Random.rand(10000000000000000000000000000000000000000000000000000000000000000000000)
      expect(number_random.to_kansuji.to_number).to eq number_random
    end
  end
end
