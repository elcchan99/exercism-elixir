defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    text
    |> to_charlist()
    |> do_rotate(shift, [])
    |> to_string()
  end

  defp do_rotate([], _, buffer), do: buffer |> Enum.reverse()

  defp do_rotate([head | tail], shift, buffer) do
    do_rotate(tail, shift, [shift_char(head, shift) | buffer])
  end

  defp shift_char(char, shift) when char in ?A..?Z do
    rem(char - ?A + shift, 26) + ?A
  end

  defp shift_char(char, shift) when char in ?a..?z do
    rem(char - ?a + shift, 26) + ?a
  end

  defp shift_char(char, _), do: char
end
