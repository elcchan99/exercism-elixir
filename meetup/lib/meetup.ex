defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @weekday_num %{
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6,
    sunday: 7
  }

  @schedule_ranges %{
    first: 1..7,
    second: 8..14,
    third: 15..21,
    fourth: 22..28,
    teenth: 13..19,
    last: 31..21
  }

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date()
  def meetup(year, month, weekday, schedule) do
    {:ok, date} =
      Date.new(
        year,
        month,
        find_day(year, month, @schedule_ranges[schedule], @weekday_num[weekday])
      )

    date
  end

  @spec find_day(pos_integer, pos_integer, pos_integer, Range.t(1, 7)) :: pos_integer
  defp find_day(year, month, day_range, weekday) do
    day_range
    |> Enum.find(fn day ->
      Calendar.ISO.valid_date?(year, month, day) and
        Calendar.ISO.day_of_week(year, month, day) == weekday
    end)
  end
end
