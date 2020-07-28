defmodule Bob do
  def hey(input) do
    trim_input = String.trim(input)
    cond do
      is_slience?(trim_input) -> "Fine. Be that way!"
      is_yell_question?(trim_input) -> "Calm down, I know what I'm doing!"
      is_yell?(trim_input) -> "Whoa, chill out!"
      is_question?(trim_input) -> "Sure."
      true -> "Whatever."
    end
  end

  defp is_yell_question?(input), do: is_yell?(input) and is_question?(input)

  defp is_yell?(input), do: String.match?(input, ~r/[a-z\p{Cyrillic}]/ui) && String.upcase(input) == input

  defp is_question?(input), do: String.ends_with?(input, "?")

  defp is_slience?(input), do: String.length(input) == 0
end
