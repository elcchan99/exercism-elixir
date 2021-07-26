defmodule DndCharacter do
  @type t :: %__MODULE__{
          strength: pos_integer(),
          dexterity: pos_integer(),
          constitution: pos_integer(),
          intelligence: pos_integer(),
          wisdom: pos_integer(),
          charisma: pos_integer(),
          hitpoints: pos_integer()
        }

  @dice 6
  @abilities [:strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma]

  defstruct ~w[strength dexterity constitution intelligence wisdom charisma hitpoints]a

  @spec modifier(pos_integer()) :: integer()
  def modifier(score) do
    (score - 10) / 2 |> floor()
  end

  @spec ability :: pos_integer()
  def ability do
    1..4
      |> Enum.map(fn _ -> throw_dice() end)
      |> Enum.sort()
      |> Enum.reverse()
      |> Enum.take(3)
      |> Enum.sum()
  end

  @spec character :: t()
  def character do
    character(%DndCharacter{}, @abilities)
  end

  def character(char, [name | rest]) when name != :hitpoints do
    char = set_ability(char, name)
    character(char, rest)
  end

  def character(char, []), do: char

  defp set_ability(char, :constitution) do
    char = char |> Map.put(:constitution, ability())
    char |> Map.put(:hitpoints, hitpoints(char))
  end

  defp set_ability(char, name) do
    char |> Map.put(name, ability())
  end

  defp hitpoints(char) do
    10 + modifier(char.constitution)
  end

  defp throw_dice(), do: :rand.uniform(@dice)
end
