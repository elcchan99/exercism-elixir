defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.downcase()
    |> String.replace(~r/!|&|@|\$|%|\^|&|:|,/u, "")
    |> String.split(~r/[\s|_]+/u)
    |> Enum.reduce(%{}, fn word, map ->
      map
      |> Map.update(word, 1, &(&1 + 1))
    end)
  end
end
