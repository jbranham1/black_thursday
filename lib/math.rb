module Math
  def average(array, round_precision)
    (sum(array) / array.length).round(round_precision)
  end

  def average_by(total_sum, total_length, round_precision)
    (total_sum.to_f / total_length).round(round_precision)
  end

  def sum(array)
    array.reduce(:+)
  end

  def standard_deviation(set, mean)
    # Take the difference between each number and the mean and square it
    step1 = set.map do |num|
      (num - mean)**2
    end

    # Sum these square differences together
    step2 = sum(step1)

    # Divide the sum by the number of elements minus 1
    step3 = step2 / (step1.length - 1)

    # Take the square root of this result
    Math.sqrt(step3).round(2)
  end
end
