defmodule Bowling do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """
  defstruct [:score, :frame, last_roll: nil, bonus: nil]

  @max_frame 10
  @bonus_frame 11
  defguard is_over(frame) when is_integer(frame) and frame not in 1..@max_frame

  @pin_no 10
  defguard is_roll_valid(roll) when roll in 0..@pin_no

  defguard is_roll_valid(roll_1, roll_2)
           when (roll_1 < @pin_no and is_roll_valid(roll_1 + roll_2)) or
                  (roll_1 == @pin_no and is_roll_valid(roll_2))

  defguard is_valid_first_throw(roll) when is_roll_valid(roll)

  defguard is_valid_second_throw(frame, roll_1, roll_2)
           when not is_over(frame) and is_roll_valid(roll_1, roll_2)

  defguard is_valid_bonus_throw(frame, roll) when is_over(frame) and is_roll_valid(roll)

  defguard is_valid_bonus_throw(frame, roll_1, roll_2)
           when is_over(frame) and is_roll_valid(roll_1, roll_2)

  defguard is_strike(roll) when roll == @pin_no

  defguard is_spare(roll_1, roll_2) when roll_1 + roll_2 == @pin_no

  @spec start() :: any
  def start do
    %Bowling{score: 0, frame: 1}
  end

  # first throw
  defp compute_bonus(roll, nil) when is_strike(roll), do: [:strike]
  defp compute_bonus(roll, [:strike]) when is_strike(roll), do: [:spare, :strike]
  defp compute_bonus(roll, [:spare, :strike]) when is_strike(roll), do: [:spare, :strike]
  defp compute_bonus(_, [:strike]), do: [:spare]
  defp compute_bonus(_, [:spare, :strike]), do: [:spare]
  defp compute_bonus(_, _), do: nil
  # second throw
  defp compute_bonus(roll_1, roll_2, _) when is_spare(roll_1, roll_2), do: [:spare]
  defp compute_bonus(_, _, _), do: nil

  defp compute_extra_bonus([:strike]), do: [:spare]
  defp compute_extra_bonus([:spare, :strike]), do: [:spare]
  defp compute_extra_bonus(_), do: nil

  defp bonus_score(nil, _), do: 0
  defp bonus_score(bonus, roll), do: roll * length(bonus)

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """
  @spec roll(any, integer) :: any | String.t()
  def roll(%Bowling{frame: frame, score: score, last_roll: nil, bonus: bonus} = game, roll)
      when not is_over(frame) and is_valid_first_throw(roll) and is_strike(roll) do
    %Bowling{
      game
      | frame: frame + 1,
        score: score + roll + bonus_score(bonus, roll),
        bonus: compute_bonus(roll, bonus)
    }
  end

  def roll(%Bowling{frame: frame, score: score, last_roll: nil, bonus: bonus} = game, roll)
      when not is_over(frame) and is_valid_first_throw(roll) do
    %Bowling{
      game
      | score: score + roll + bonus_score(bonus, roll),
        last_roll: roll,
        bonus: compute_bonus(roll, bonus)
    }
  end

  def roll(%Bowling{frame: frame, score: score, last_roll: last_roll, bonus: bonus} = game, roll)
      when not is_over(frame) and is_valid_second_throw(frame, last_roll, roll) do
    %Bowling{
      game
      | frame: frame + 1,
        score: score + roll + bonus_score(bonus, roll),
        last_roll: nil,
        bonus: compute_bonus(last_roll, roll, bonus)
    }
  end

  def roll(
        %Bowling{
          frame: @bonus_frame,
          score: score,
          last_roll: nil,
          bonus: [:spare] = bonus
        } = game,
        roll
      )
      when is_roll_valid(roll) do
    # Last bonus roll
    %Bowling{
      game
      | score: score + bonus_score(bonus, roll),
        last_roll: nil,
        bonus: nil
    }
  end

  def roll(
        %Bowling{frame: @bonus_frame, last_roll: last_roll, bonus: [:spare]} = game,
        roll
      )
      when (is_strike(last_roll) and is_roll_valid(roll)) or
             (not is_strike(last_roll) and is_roll_valid(last_roll, roll)) do
    # Second bonus roll if got strike or spare in first bonus roll
    # sample calculation as last bonus roll
    roll(%Bowling{game | last_roll: nil}, roll)
  end

  def roll(
        %Bowling{frame: @bonus_frame, score: score, last_roll: nil, bonus: [_h | _d] = bonus} =
          game,
        roll
      )
      when is_roll_valid(roll) do
    # First Strike bonus roll
    %Bowling{
      game
      | score: score + bonus_score(bonus, roll),
        last_roll: roll,
        bonus: compute_extra_bonus(bonus)
    }
  end

  def roll(%Bowling{frame: frame, last_roll: nil, bonus: nil}, roll)
      when is_valid_bonus_throw(frame, roll) do
    {:error, "Cannot roll after game is over"}
  end

  def roll(%Bowling{frame: frame, last_roll: last_roll, bonus: nil}, roll)
      when is_valid_bonus_throw(frame, last_roll, roll) do
    {:error, "Cannot roll after game is over"}
  end

  def roll(_, roll) when roll < 0 do
    {:error, "Negative roll is invalid"}
  end

  def roll(%Bowling{last_roll: nil}, roll) when not is_roll_valid(roll) do
    {:error, "Pin count exceeds pins on the lane"}
  end

  def roll(%Bowling{last_roll: last_roll}, roll) when not is_roll_valid(last_roll, roll) do
    {:error, "Pin count exceeds pins on the lane"}
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """

  @spec score(any) :: integer | String.t()
  def score(%Bowling{frame: frame, score: score, bonus: nil}) when is_over(frame) do
    score
  end

  def score(_) do
    {:error, "Score cannot be taken until the end of the game"}
  end
end
