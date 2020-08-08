defmodule Strain do
  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns true.

  Do not use `Enum.filter`.
  """
  @spec keep(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def keep(list, fun) do
    do_keep(list, fun)
  end

  defp do_keep([], _), do: []

  defp do_keep([head|tail], fun) do
    cond do
      fun.(head)-> [head | do_keep(tail, fun)]
      true -> do_keep(tail, fun)
    end
  end

  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns false.

  Do not use `Enum.reject`.
  """
  @spec discard(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def discard(list, fun) do
    do_discard(list, fun)
  end

  defp do_discard([], fun), do: []

  defp do_discard([head|tail], fun) do
    cond do
      fun.(head)-> do_discard(tail, fun)
      true -> [head | do_discard(tail, fun)]
    end
  end
end
