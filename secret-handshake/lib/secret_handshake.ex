defmodule SecretHandshake do
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  use Bitwise

  defguard is_bits_match(code, bits) when (code &&& bits) == bits

  def commands(code) when is_bits_match(code, 16) do
    commands(code &&& bnot(16)) |> Enum.reverse()
  end

  def commands(code) when is_bits_match(code, 1) do
    ["wink" | commands(code &&& bnot(1))]
  end

  def commands(code) when is_bits_match(code, 2) do
    ["double blink" | commands(code &&& bnot(2))]
  end

  def commands(code) when is_bits_match(code, 4) do
    ["close your eyes" | commands(code &&& bnot(4))]
  end

  def commands(code) when is_bits_match(code, 8) do
    ["jump" | commands(code &&& bnot(8))]
  end

  def commands(_), do: []
end
