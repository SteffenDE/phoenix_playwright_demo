defmodule PlaywrightTestsWeb.InitAssigns do
  import Phoenix.LiveView

  alias PlaywrightTests.Accounts
  alias PlaywrightTestsWeb.Router.Helpers, as: Routes

  def on_mount(:ensure_user, _params, %{"user_token" => token} = _session, socket) do
    socket
    |> assign_new(:current_user, fn ->
      Accounts.get_user_by_session_token(token)
    end)
    |> then(fn socket ->
      if is_nil(socket.assigns.current_user) do
        {:halt, redirect_require_login(socket)}
      else
        {:cont, socket}
      end
    end)
  end

  defp redirect_require_login(socket) do
    socket
    |> put_flash(:error, "You must log in to access this page.")
    |> redirect(to: Routes.user_session_path(socket, :new))
  end
end
