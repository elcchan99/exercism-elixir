defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  defguard is_numeric(c) when c in ?0..?9

  @spec encode(String.t()) :: String.t()
  def encode(s) when is_binary(s) do
    s |> String.graphemes() |> do_encode()
  end

  defp do_encode(string, count \\ 1)
  defp do_encode([], _), do: ""

  defp do_encode([c | []], count) do
    render_encoded(c, count)
  end

  defp do_encode([c1, c2 | tail], count) when c1 != c2 do
    render_encoded(c1, count) <> do_encode([c2 | tail])
  end

  defp do_encode([c1, c2 | tail], count) when c1 == c2 do
    do_encode([c2 | tail], count + 1)
  end

  defp render_encoded(c, count) when count == 1, do: c
  defp render_encoded(c, count) when count > 1, do: Integer.to_string(count) <> c

  @spec decode(String.t()) :: String.t()
  def decode(s) do
    s |> String.to_charlist() |> do_decode()
  end

  defp do_decode(charlist, count \\ 0)
  defp do_decode([], _), do: ""

  defp do_decode([c | tail], count) when is_numeric(c) do
    do_decode(tail, count * 10 + parse_numeric_char(c))
  end

  defp do_decode([c | tail], count) do
    render_decoded(c, count) <> do_decode(tail)
  end

  defp parse_numeric_char(c), do: c - ?0

  defp render_decoded(c, 0), do: render_decoded(c, 1)
  defp render_decoded(c, count), do: replicate(count, c) |> List.to_string()

  defp replicate(n, x), do: for(_ <- 1..n, do: x)
end
