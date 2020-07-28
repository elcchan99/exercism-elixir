defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number) when number in 1000..3000, do: "M" <> numeral(number - 1000)

  def numeral(number) when number in 900..999, do: "CM" <> numeral(number - 900)

  def numeral(number) when number in 500..899, do: "D" <> numeral(number - 500)

  def numeral(number) when number in 400..499, do: "CD" <> numeral(number - 400)

  def numeral(number) when number in 100..399, do: "C" <> numeral(number - 100)

  def numeral(number) when number in 90..99, do: "XC" <> numeral(number - 90)

  def numeral(number) when number in 50..89, do: "L" <> numeral(number - 50)

  def numeral(number) when number in 40..49, do: "XL" <> numeral(number - 40)

  def numeral(number) when number in 10..39, do: "X" <> numeral(number - 10)

  def numeral(number) when number == 9, do: "IX"

  def numeral(number) when number in 5..8, do: "V" <> numeral(number - 5)

  def numeral(number) when number == 4, do: "IV"

  def numeral(number) when number in 1..3, do: "I" <> numeral(number - 1)

  def numeral(number), do: ""
end
