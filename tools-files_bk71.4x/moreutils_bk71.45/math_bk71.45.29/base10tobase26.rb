module Base26
  ALPHA = ('a'..'z').to_a

  module Number
    def to_s26
      # initialize an empty string
      str = ''

      # return that string if
      # value is not at least 1
      # which would be 'a'
      return str if self < 1

      # initialize quotient to this value
      quotient = self

      # until we get to 0
      until quotient.zero?
        # get the result and remainder
        # of (q - 1) / 26
        quotient, remainder = (quotient - 1).divmod(26)

        # prepent that str with
        # the value at the index of
        # the remainder
        str.prepend(ALPHA[remainder]) 
      end
      str
    end
  end
end


class Fixnum
  include Base26
  include Base26::Number
end


class Bignum
  include Base26
  include Base26::Number
end


class String
  include Base26

  def to_i26
    # initialize the return value to 0
    result = 0

    # ensure we only have lowercase alpha chars
    downcase!
    gsub!(/[^a-z]/, '')

    # iterate backwards over string
    (1..length).each do |index|
      # get char at index
      char = self[-index]

      # get numeric position in alpha
      position = ALPHA.index(char)

      # get the value of 26
      # to the power of the current index
      power = 26**(index - 1)

      # compensate for array being 0 indexed
      position += 1

      # add to result
      result += power * position
    end
    result
  end
end


if __FILE__ == $0
  num = ARGV[0]
#  puts num
  puts num.to_i.to_s26
end
