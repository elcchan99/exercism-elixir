defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @letter_only_regex ~r/[^\P{L}]/u

  @spec frequency([String.t()], pos_integer) :: map
  def frequency([], _), do: %{}

  def frequency(texts, workers) do
    texts
    |> Task.async_stream(&count_letters/1, max_concurrency: workers)
    |> merge_result()
  end

  defp is_letter?(string), do: String.match?(string, @letter_only_regex)

  defp count_letters(""), do: %{}

  defp count_letters(text) do
    text
    |> String.downcase()
    |> String.graphemes()
    |> Enum.filter(&is_letter?/1)
    |> Enum.frequencies_by(& &1)
  end

  defp merge_result(results) do
    results
    |> Enum.reduce(%{}, fn {:ok, map}, acc ->
      Map.merge(acc, map, fn _key, val1, val2 -> val1 + val2 end)
    end)
  end
end
