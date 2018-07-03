module Kansuji
  class << self; attr_reader :init_num_char end
  @init_num_char = { 10**68 => '無量大数', 10**64 => '不可思議', 10**60 => '那由他', 10**56 => '阿僧祇',
                     10**52 => '恒河沙', 10**48 => '極', 10**44 => '載', 10**40 => '正', 10**36 => '澗',
                     10**32 => '溝', 10**28 => '穣', 10**24 => '𥝱', 10**20 => '垓', 10**16 => '京', 10**12 => '兆',
                     10**8 => '億', 10000 => '万', 1000 => '千', 100 => '百', 10 => '十', 9 => '九', 8 => '八',
                     7 => '七', 6 => '六', 5 => '五', 4 => '四', 3 => '三', 2 => '二', 1 => '一', 0 => '零' }
end

class Numeric
  include Kansuji
  def num_to_kan(num)
    return Kansuji.init_num_char[num] unless Kansuji.init_num_char[num].nil?; f_num, fval, sec = nil
    Kansuji.init_num_char.each do |key, value|
      (f_num = num / key; fval = value; sec = num - f_num * key; break) if num / key >= 1
    end
    return (num_to_kan(f_num) + fval + num_to_kan(sec)) if f_num != 1 && sec != 0
    return (fval + num_to_kan(sec)) if f_num == 1 && sec != 0
    return (num_to_kan(f_num) + fval) if sec == 0 && f_num != 1
  end

  def to_kansuji
    return raise_error(NoMethodError) unless is_a? Integer
    result, index_max, value  = num_to_kan(self), -1, -1
    Kansuji.init_num_char.invert.each do |k, v|
      (index_max = result.index(k); value = v; break) if result.include?(k)
    end
    return '一' + result if index_max == 0 && value >= 10000; result
  end
end

class String
  include Kansuji
  def kan_to_num(kan)
    return Kansuji.init_num_char.invert[kan] unless Kansuji.init_num_char.invert[kan].nil?
    index_max, value, key = nil
    Kansuji.init_num_char.invert.each do |k, v|
      (index_max = kan.index(k); value = v; key = k; break) if kan.include?(k)
    end
    (return (value + kan_to_num(kan[key.length..kan.length - 1])) unless kan[key.length].nil?; return value) if index_max == 0
    return kan_to_num(kan[0..index_max - 1]) * value + kan_to_num(kan[index_max + key.length..kan.length - 1]) unless kan[index_max + key.length].nil?
    kan_to_num(kan[0..index_max - 1]) * value
  end

  def to_number
    raise_error(NoMethodError) unless is_a? String; return 0 if gsub(/[\w]|[\s]/, '') == ''
    kan_to_num(gsub(/[\w]|[\s]/, ''))
  end
end