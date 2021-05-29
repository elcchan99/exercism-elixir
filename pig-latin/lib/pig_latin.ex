defmodule PigLatin do
  @moduledoc """
  PigLatin exercise

  https://exercism.io/my/solutions/a7f1c0bf53274fc28dfd569d23d68a4a
  """

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrases) do
    phrases
    |> String.split(" ")
    |> Enum.map(&translate_single/1)
    |> Enum.join(" ")
  end

  def translate_single(phrase) do
    String.to_charlist(phrase)
    |> do_translate()
    |> List.to_string()
  end

  defguard is_vowel(char) when char in [?a, ?e, ?i, ?o, ?u]
  defguard is_consonant(char) when not is_vowel(char)

  defp do_translate([]), do: []

  defp do_translate([first | _] = phrase) when is_vowel(first), do: append_ay(phrase)
  defp do_translate([?x, second | _] = phrase) when is_consonant(second), do: append_ay(phrase)
  defp do_translate([?y, second | _] = phrase) when is_consonant(second), do: append_ay(phrase)

  defp do_translate([?q, ?u | rest]), do: do_translate(rest ++ [?q, ?u])
  defp do_translate([first | rest]) when is_consonant(first), do: do_translate(rest ++ [first])

  defp append_ay(phrase), do: phrase ++ [?a, ?y]
end
