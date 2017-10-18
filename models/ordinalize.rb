# From the active support gem in rails, not my work.
class Integer
  def ordinalize
    if (11..13).cover?(self % 100)
      "#{self}th"
    else
      case self % 10
      when 1 then "#{self}st"
      when 2 then "#{self}nd"
      when 3 then "#{self}rd"
      else "#{self}th"
      end
    end
  end
end
