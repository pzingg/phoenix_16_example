defmodule Example16.Repo do
  use Ecto.Repo,
    otp_app: :example_16,
    adapter: Ecto.Adapters.Postgres
end
