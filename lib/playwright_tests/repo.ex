defmodule PlaywrightTests.Repo do
  use Ecto.Repo,
    otp_app: :playwright_tests,
    adapter: Ecto.Adapters.Postgres
end
