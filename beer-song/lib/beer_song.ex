defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(0) do
    # Your implementation here...
    """
    No more bottles of beer on the wall, no more bottles of beer.
    Go to the store and buy some more, 99 bottles of beer on the wall.
    """
  end

  def verse(1) do
    """
    1 bottle of beer on the wall, 1 bottle of beer.
    Take it down and pass it around, no more bottles of beer on the wall.
    """
  end

  def verse(2) do
    """
    2 bottles of beer on the wall, 2 bottles of beer.
    Take one down and pass it around, 1 bottle of beer on the wall.
    """
  end

  def verse(number) do
    # Your implementation here...
    """
    #{number} bottles of beer on the wall, #{number} bottles of beer.
    Take one down and pass it around, #{number - 1} bottles of beer on the wall.
    """
  end

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range \\ 99..0) do
    # Your implementation here...
    range
    |> Enum.map(&verse(&1))
    |> Enum.join("\n")
  end

  # Below is the minimum duplication version

  # def verse(number) do
  #   # Your implementation here...
  #   """
  #   #{bottle(number) |> upcaseFirst()} of beer on the wall, #{bottle(number)} of beer.
  #   #{take_phrase(number)}, #{remain_phrase(number - 1)}.
  #   """
  # end

  # defp bottle(0), do: "no more bottles"
  # defp bottle(1), do: "1 bottle"
  # defp bottle(number), do: "#{number} bottles"

  # defp take_phrase(0), do: "Go to the store and buy some more"
  # defp take_phrase(1), do: "Take it down and pass it around"
  # defp take_phrase(_), do: "Take one down and pass it around"

  # defp remain_phrase(number) when number < 0, do: remain_phrase(99)
  # defp remain_phrase(number), do: "#{bottle(number)} of beer on the wall"

  # defp upcaseFirst(<<first::utf8, rest::binary>>), do: String.upcase(<<first::utf8>>) <> rest
end
