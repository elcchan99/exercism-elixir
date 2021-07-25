defmodule SpaceAge do
  @type planet ::
          :mercury
          | :venus
          | :earth
          | :mars
          | :jupiter
          | :saturn
          | :uranus
          | :neptune

  @earth_year_seconds 31_557_600

  @rel_to_earh_year [
    mercury: 0.240_846_7,
    venus: 0.615_197_26,
    mars: 1.8808158,
    jupiter: 11.862615,
    saturn: 29.447498,
    uranus: 84.016846,
    neptune: 164.79132
  ]

  @doc """
  Return the number of years a person that has lived for 'seconds' seconds is
  aged on 'planet'.
  """
  @spec age_on(planet, pos_integer) :: float
  def age_on(:earth, seconds) do
    seconds / @earth_year_seconds
  end

  def age_on(planet, seconds) do
    age_on(:earth, seconds) / @rel_to_earh_year[planet]
  end
end
