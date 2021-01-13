module Mathable
  def average(array)
    (array.sum.to_f / array.length).round(2)
  end

  def standard_deviation(set, mean)
    # Take the difference between each number and the mean and square it
    step1 = set.map do |num|
      (num - mean)**2
    end

    # Sum these square differences together
    step2 = step1.sum

    # Divide the sum by the number of elements minus 1
    step3 = step2 / (step1.length - 1)

    # Take the square root of this result
    Math.sqrt(step3).round(2)
  end

  def percentage(numerator, denominator)
    ((numerator.to_f / denominator) * 100).round(2)
  end
end
