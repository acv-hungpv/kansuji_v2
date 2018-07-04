module Kansuji
  class << self; attr_reader :init_num_char end
  @init_num_char = { 10**68 => '無量大数', 10**64 => '不可思議', 10**60 => '那由他', 10**56 => '阿僧祇',
                     10**52 => '恒河沙', 10**48 => '極', 10**44 => '載', 10**40 => '正', 
                     10**36 => '澗', 10**32 => '溝', 10**28 => '穣', 10**24 => '𥝱', 
                     10**20 => '垓', 10**16 => '京', 10**12 => '兆', 10**8 => '億', 10000 => '万',
                     1000 => '千', 100 => '百', 10 => '十', 9 => '九', 8 => '八', 7 => '七',
                     6 => '六', 5 => '五', 4 => '四', 3 => '三', 2 => '二', 1 => '一', 0 => '零' }
end

class Integer
  def num_to_kan(num)
    return Kansuji.init_num_char[num] unless Kansuji.init_num_char[num].nil?
    key, value = Kansuji.init_num_char.find { |k, v| num / k >= 1 }
    f_num = num / key; fval = value; sec = num - f_num * key
    return (num_to_kan(f_num) + fval + num_to_kan(sec)) if f_num != 1 && sec != 0
    return (fval + num_to_kan(sec)) if f_num == 1 && sec != 0
    return (num_to_kan(f_num) + fval) if sec == 0 && f_num != 1
  end

  def to_kansuji
    result = num_to_kan(self)
    key, value = Kansuji.init_num_char.invert.find { |k, v| result.include?(k) }
    return '一' + result if result.index(key) == 0 && value >= 10000; result
  end
end

class String
  def to_number(kan = self.gsub(/[\w]|[\s]/, ''))
    return 0 if kan == ''
    return Kansuji.init_num_char.invert[kan] unless Kansuji.init_num_char.invert[kan].nil?
    key, value = Kansuji.init_num_char.invert.find { |k, v| kan.include?(k) }
    (return (value + to_number(kan[key.length..kan.length - 1])) unless kan[key.length].nil?;\
                                                               return value) if kan.index(key) == 0
    return to_number(kan[0..kan.index(key) - 1]) * value + to_number(kan[kan.index(key) + \
                key.length..kan.length - 1]) unless kan[kan.index(key) + key.length].nil?
    return to_number(kan[0..kan.index(key) - 1]) * value
  end
end