defmodule PlaywrightTestsWeb.AllowEctoSandbox do
  @moduledoc false

  import Phoenix.LiveView

  def on_mount(:default, _params, _session, socket) do
    allow_ecto_sandbox(socket)
    {:cont, socket}
  end

  defp allow_ecto_sandbox(socket) do
    %{assigns: %{phoenix_ecto_sandbox: metadata}} =
      assign_new(socket, :phoenix_ecto_sandbox, fn ->
        if connected?(socket), do: Phoenix.LiveView.get_connect_info(socket, :user_agent)
      end)

    if metadata, do: Phoenix.Ecto.SQL.Sandbox.allow(metadata, Ecto.Adapters.SQL.Sandbox)
  end
end
