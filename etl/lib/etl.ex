defmodule ETL do
  @doc """
  Transform an index into an inverted index.

  ## Examples

  iex> ETL.transform(%{"a" => ["ABILITY", "AARDVARK"], "b" => ["BALLAST", "BEAUTY"]})
  %{"aardvark" => "a", "ability" => "a", "ballast" => "b", "beauty" => "b"}
  """
  @spec transform(map) :: map
  def transform(input) do
    for {score, words} <- input, word <- words, into: %{} do
      {String.downcase(word), score}
    end

    # Enum.reduce(input, %{}, fn {k, v}, acc ->
    #   Enum.map(v, &String.downcase/1)
    #   |> Enum.reduce(acc, fn dv, acc ->
    #     Map.put(acc, dv, k)
    #   end)
    # end)
  end
end
