defmodule Zen do
  use Application

  def start(_type, _args) do
    Zen.Supervisor.start_link
  end

  def main(args) do
    args |> parse_args |> do_process
  end
  def parse_args(args) do
    options = OptionParser.parse(args)
    case options do
      {[goal: goal], _, _} -> [goal]
      {[help: true], _, _} -> :help
      _ -> :help
    end
  end

  def meditateOn(goal) do
    repo = %Git.Repository{path: "."}
    {:ok, status} = Git.checkout repo, ["-b", "f-zen-#{strip_spaces(goal)}"]
    status |> parse_status |> meditate_msg |> IO.puts
  end

  def strip_spaces(string) do
    string |> String.replace(" ","-")
  end

  def parse_status(status_string) do
    status_string |> run_regex |> hd
  end

  def meditate_msg(branch) do
    "You're now meditating on #{branch}"
  end

  defp run_regex(str) do
    Regex.run(~r/f-zen-.+/,str)
  end

  defp do_process([change]) do
    meditateOn(change)
  end

  defp do_process(:help) do
    IO.puts "This is help message"
  end

end
