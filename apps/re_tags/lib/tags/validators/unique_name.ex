defmodule ReTags.Tags.Validators.UniqueName do
  use Vex.Validator

  alias ReTags.Tags

  def validate(value, _context) do
    case Tags.by_name(value) do
      {:ok, _tag} -> {:error, "has already been taken"}
      _ -> :ok
    end
  end
end
