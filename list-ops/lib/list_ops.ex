defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l), do: do_count(l, 0)

  defp do_count([], sum), do: sum
  defp do_count([_ | tail], sum), do: do_count(tail, sum + 1)

  @spec reverse(list) :: list
  def reverse(l), do: do_reverse(l, [])

  defp do_reverse([], buffer), do: buffer
  defp do_reverse([head | tail], buffer), do: do_reverse(tail, [head | buffer])

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: do_map(l, f)

  defp do_map([], f), do: []
  defp do_map([head | tail], f), do: [f.(head) | do_map(tail, f)]

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: do_filter(l, f)

  defp do_filter([], f), do: []

  defp do_filter([head | tail], f) do
    case f.(head) do
      true -> [head | do_filter(tail, f)]
      false -> do_filter(tail, f)
    end
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce(l, acc, f), do: do_reduce(l, acc, f)

  defp do_reduce([], acc, _), do: acc
  defp do_reduce([head | tail], acc, f), do: do_reduce(tail, f.(head, acc), f)

  @spec append(list, list) :: list
  def append(a, b), do: do_append(a, b, [])

  defp do_append([], [], buffer), do: reverse(buffer)
  defp do_append([head | tail], b, buffer), do: do_append(tail, b, [head | buffer])
  defp do_append(a, [head | tail], buffer), do: do_append(a, tail, [head | buffer])

  @spec concat([[any]]) :: [any]
  def concat(l), do: do_concat(l, [], [])

  defp do_concat([], [], buffer), do: reverse(buffer)
  defp do_concat(l, [head | tail], buffer), do: do_concat(l, tail, [head | buffer])
  defp do_concat([head | tail], [], buffer), do: do_concat(tail, head, buffer)
end
