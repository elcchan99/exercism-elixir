defmodule RobotSimulator do
  defmodule Robot do
    defstruct [:direction, :position]
  end

  @turn_left_map %{:north => :west, :west => :south, :south => :east, :east => :north}
  @turn_right_map %{:north => :east, :east => :south, :south => :west, :west => :north}

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  def create(direction \\ :north, position \\ {0, 0})

  def create(direction, _)
      when not (is_atom(direction) and direction in [:north, :south, :east, :west]) do
    {:error, "invalid direction"}
  end

  def create(_, position) when not (is_tuple(position) and tuple_size(position) == 2) do
    {:error, "invalid position"}
  end

  def create(_, {x, y}) when not is_integer(x) or not is_integer(y) do
    {:error, "invalid position"}
  end

  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction, position) do
    %Robot{direction: direction, position: position}
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """

  def simulate({:error, msg}, _) do
    {:error, msg}
  end

  def simulate(robot, ?A) do
    {x, y} = robot.position

    case robot.direction do
      :north -> %Robot{robot | position: {x, y + 1}}
      :south -> %Robot{robot | position: {x, y - 1}}
      :east -> %Robot{robot | position: {x + 1, y}}
      :west -> %Robot{robot | position: {x - 1, y}}
    end
  end

  def simulate(robot, ?L) do
    %Robot{robot | direction: @turn_left_map[robot.direction]}
  end

  def simulate(robot, ?R) do
    %Robot{robot | direction: @turn_right_map[robot.direction]}
  end

  def simulate(robot, []), do: robot

  def simulate(robot, [head | tail]) do
    robot
    |> simulate(head)
    |> simulate(tail)
  end

  def simulate(robot, instructions) when not is_bitstring(instructions) do
    {:error, "invalid instruction"}
  end

  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    simulate(robot, to_charlist(instructions))
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot) do
    robot.direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot) do
    robot.position
  end
end
