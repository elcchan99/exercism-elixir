defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string
    |> tokenize()
    |> Enum.map(&String.at(&1, 0))
    |> Enum.map(&String.upcase/1)
    |> Enum.join("")
  end

  defp tokenize(string) do
    string
    |> insert_space_before_upper_char()
    |> String.split(~r/[-\t\s_]+/i, trim: true)
  end

  defp insert_space_before_upper_char(string) do
    string
    |>  String.replace(~r/([a-z])([A-Z])/, "\\1 \\2")
  end
end
