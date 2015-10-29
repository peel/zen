defmodule ZenRepo do
  @moduledoc """
  Encapsulates data regarding git repository and its state.
  """

  defstruct git: nil, branch: nil
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
    case checkout(repo(".","f-zen"), goal) do
      {:ok, repo} -> "You're now meditating on #{repo.branch}"
      {:error, _} -> "Failed. Clear your mind and repository."
    end
  end

  defp repo(path \\ ".", branch \\ "f-zen") do
    git = %Git.Repository{path: path}
    %ZenRepo{git: git, branch: branch}
  end

  @spec checkout(ZenRepo, String.t) :: ZenRep
  defp checkout(repo, goal) do
    new_branch = "#{repo.branch}-#{strip_spaces(goal)}"
    case Git.checkout repo.git, ["-b", new_branch] do
      {:ok, _} -> {:ok, %{repo | branch: new_branch}}
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
