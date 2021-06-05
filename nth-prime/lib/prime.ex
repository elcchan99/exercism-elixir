defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) when count >= 1 do
    Stream.unfold(2, fn n -> {n, n + 1} end)
    |> Stream.filter(&is_prime/1)
    |> Stream.take(count)
    |> Enum.at(-1)
  end

  def is_prime(1), do: false

  def is_prime(n) do
    mul =
      2..n
      |> Enum.filter(fn x -> rem(n, x) == 0 end)
      |> length()

    mul == 1
  end
end
