defmodule ChatterWeb.SessionController do
  require Logger
  use ChatterWeb, :controller
  import ChatterWeb.Auth

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => user, "password" => password}}) do
    case login_with(conn, user, password) do
      {:ok, conn} ->
        logged_user = Guardian.Plug.current_resource(conn)

        conn
        |> put_flash(:info, "Registrado!")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Error Username/Password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out
    |> redirect(to: "/")
  end
end
