defmodule PlaywrightTestsWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :playwright_tests

  # see https://hexdocs.pm/phoenix_ecto/Phoenix.Ecto.SQL.Sandbox.html
  if Mix.env() == :e2e do
    plug(Phoenix.Ecto.SQL.Sandbox,
      at: "/sandbox",
      repo: PlaywrightTest.Repo,
      timeout: 35_000
    )
  end

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_playwright_tests_key",
    signing_salt: "PZSOP9AL"
  ]

  if Mix.env() == :e2e do
    # end to end test ecto sql sandbox needs the user-agent header
    socket("/live", Phoenix.LiveView.Socket,
      websocket: [connect_info: [:user_agent, session: @session_options]]
    )
  else
    socket("/live", Phoenix.LiveView.Socket,
      websocket: [connect_info: [session: @session_options]]
    )
  end

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :playwright_tests,
    gzip: false,
    only: ~w(assets fonts images favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :playwright_tests
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug PlaywrightTestsWeb.Router
end
