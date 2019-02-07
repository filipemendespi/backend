defmodule ReTags.Repo do
  use Ecto.Repo,
    otp_app: :re_tags,
    adapter: Ecto.Adapters.Postgres
end
