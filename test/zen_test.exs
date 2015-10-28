defmodule ZenTest do
  use ExUnit.Case
  doctest Zen

  setup do
    branch_name = "some-goal"
    repo = %Git.Repository{path: "."}
    Git.checkout(repo, "master")
    Git.branch(repo,["-d", "f-zen-#{branch_name}"])
    :ok
  end

  test "meditate_on creates a branch" do
    assert Zen.meditate_on("some-goal") == "You're now meditating on f-zen-some-goal"
  end
end
