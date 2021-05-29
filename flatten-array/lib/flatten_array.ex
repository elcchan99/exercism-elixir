defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten([]), do: []

  def flatten([e | tail]) when is_list(e) do
    flatten(e) ++ flatten(tail)
  end

  def flatten([e | tail]) when is_nil(e), do: flatten(tail)

  def flatten([e | tail]) do
    [e | flatten(tail)]
  end
end
