defmodule ProteinTranslation do
  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {atom, list(String.t())}
  def of_rna(rna) do
    proteins =
      rna
      |> IO.inspect()
      |> Stream.chunk_every(3)
      |> IO.inspect()
      |> Stream.map(&of_codon(&1))
      |> Stream.transform({[], false}, fn protein, {acc, stopped} ->
        cond do
          stopped ->
            {nil, {acc, stopped}}

          true ->
            case protein do
              "STOP" -> {nil, {acc, true}}
              _ -> {protein, {acc, stopped}}
            end
        end
      end)
      |> Enum.to_list()

    case length(rna) do
      0 -> {:error, "Invalid RNA"}
      _ -> {:ok, proteins}
    end
  end

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  @codon_protein_map %{
    "UGU" => "Cysteine",
    "UGC" => "Cysteine",
    "UUA" => "Leucine",
    "UUG" => "Leucine",
    "AUG" => "Methionine",
    "UUU" => "Phenylalanine",
    "UUC" => "Phenylalanine",
    "UCU" => "Serine",
    "UCC" => "Serine",
    "UCA" => "Serine",
    "UCG" => "Serine",
    "UGG" => "Tryptophan",
    "UAU" => "Tyrosine",
    "UAC" => "Tyrosine",
    "UAA" => "STOP",
    "UAG" => "STOP",
    "UGA" => "STOP"
  }
  @spec of_codon(String.t()) :: {atom, String.t()}
  def of_codon(codon) do
    case Map.fetch(@codon_protein_map, codon) do
      {:error} -> {:error, "Invalid codon"}
      {:ok, protein} -> {:ok, protein}
    end
  end
end
