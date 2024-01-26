defmodule ByoxApi.Repo do
  use Ecto.Repo,
    otp_app: :byox_api,
    adapter: Ecto.Adapters.Postgres
end
