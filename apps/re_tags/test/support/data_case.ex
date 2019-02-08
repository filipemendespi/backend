defmodule ReTags.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias ReTags.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import ReTags.DataCase
    end
  end

  setup do
    ReTags.Storage.reset!()

    :ok
  end
end
