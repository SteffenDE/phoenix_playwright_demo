import Config

config :playwright_tests, PlaywrightTests.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "playwright_tests_e2e",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :playwright_tests, PlaywrightTestsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  secret_key_base: "jNCRWZFD0wE3xJqpqfJUAEeGGCj045LHIknrbQtZ9ZMXmSyFFJ5yAlpEcvSZEocY",
  server: true

# Print only warnings and errors during test
config :logger, level: :warn
