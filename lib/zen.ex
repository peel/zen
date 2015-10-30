defmodule ZenRepo do
  @moduledoc """
  Encapsulates data regarding git repository and its state.
  """

  defstruct git: nil, branches: %{source: nil, parent: nil, current: nil}
end

defmodule Zen do
  use Application

  @moduledoc """
  Zen is a CLI wrapper for `Zen of Refactoring`'s Mikado Method automation.
  """

  def start(_type, _args) do
    Zen.Supervisor.start_link
  end

  def main(args) do
    args |> parse_and_process |> IO.puts
  end

  def parse_and_process(args) do
    args |> parse_args |> do_process
  end

  defp parse_args(args) do
    options = OptionParser.parse(args,
                                 switches: [help: :boolean,
                                            goal: :string,
                                            experiment: :string,
                                            back: :boolean,
                                            graph: :string],
                                 aliases: [h: :help,
                                           g: :goal,
                                           e: :experiment,
                                           b: :back,
                                           g: :graph])
    case options do
      {[help: true], _, _} -> :help
      {[back: true], _, _} -> :back
      {[options], _, _} -> [options]
      _ -> :help
    end
  end

  @spec meditate_on(String.t) :: String.t
  def meditate_on(goal) do
    case checkout(repo, goal) do
      {:ok, repo} -> "You're now meditating on #{repo.branches.current}"
      {:error, _} -> "Failed. Clear your mind and repository."
    end
  end

  def git(path \\ ".") do
    %Git.Repository{path: path}
  end

  def repo(path \\ ".", branches \\ %{source: current_branch, previous: current_branch, current: "f-zen"}) do
    %ZenRepo{git: git, branches: branches}
  end

  def current_branch(git \\ git) do
    {:ok, branch_rev} = Git.rev_parse(git,["--abbrev-ref","HEAD"])
    branch_rev |> String.strip
  end

  @spec checkout(ZenRepo, String.t) :: ZenRep
  defp checkout(repo, goal) do
    new_branch = "#{repo.branches.current}-#{strip_spaces(goal)}"
    case Git.checkout repo.git, ["-b", new_branch] do
      {:ok, _} -> {:ok, %{repo | branches: %{repo.branches | previous: current_branch, current: new_branch}}}
      {:error, _} -> {:error, repo}
    end
  end

  defp strip_spaces(string) do
    string |> String.replace(" ","-")
  end

  defp do_process([options]) do
    case options do
      {:goal, a_goal} -> meditate_on(a_goal)
      {:experiment, an_experiment} -> meditate_on(an_experiment)
    end
  end

  defp do_process(:back) do
    "Going back..."
  end

  defp do_process(:help) do
    "This is help message"
  end

end
