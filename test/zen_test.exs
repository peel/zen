defmodule ZenTest do
  use ExUnit.Case
  doctest Zen

  test "meditation start prints welcome message" do
    str = "Switched to a new branch 'f-zen-aaa'" |> Zen.parse_status |> Zen.meditate_msg
    assert "You're now meditating on f-zen-aaa" == str
  end
end
