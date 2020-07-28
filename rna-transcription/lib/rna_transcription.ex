defmodule RnaTranscription do
  @dna_rna_map %{?G => ?C, ?C => ?G, ?T => ?A, ?A => ?U}

  def to_rna(dna) when is_integer(dna) do
    @dna_rna_map[dna]
  end

  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RnaTranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna), do: Enum.map(dna, &to_rna(&1))
end
