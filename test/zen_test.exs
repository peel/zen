defmodule ZenTest do
  use ExUnit.Case
  doctest Zen

  @goal = "some-goal"

  setup do
    new_branch_name = @goal
    repo = %Git.Repository{path: "."}
    {:ok, branch_rev} = Git.rev_parse(repo,["--abbrev-ref","HEAD"])
    branch_name = branch_rev |> String.strip
    IO.puts "Starting work from #{branch_name}"

    on_exit fn ->
      IO.puts "checking out #{branch_name}"
      Git.checkout repo, [branch_name]
      IO.puts "removing f-zen-#{new_branch_name}"
      Git.branch(repo,["-D", "f-zen-#{new_branch_name}"])
    end
  end

  test "meditate_on creates a branch" do
    assert Zen.meditate_on(@goal) == "You're now meditating on f-zen-some-goal"
  end

end
