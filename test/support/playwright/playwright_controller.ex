defmodule PlaywrightTestsWeb.TestHelpers.PlaywrightController do
  use PlaywrightTestsWeb, :controller
  alias PlaywrightTests.Accounts

  ######## Registration ########

  defp register_params do
    %{
      "email" => "test-playwright-#{System.unique_integer()}@foobar.com",
      "password" => "ThisIsAVerySecurePassword123!"
    }
  end

  defp register_user(conn) do
    p = register_params()
    {:ok, user} = Accounts.register_user(p)

    conn
    |> assign(:register_params, p)
    |> assign(:user, user)
  end

  defp render_user_response(%{assigns: assigns} = conn) do
    resp =
      Map.merge(assigns.register_params, %{
        user_id: assigns.user.id
      })

    json(conn, resp)
  end

  # register user
  def register(conn, params) do
    conn
    |> register_user()
    |> render_user_response()
  end
end
