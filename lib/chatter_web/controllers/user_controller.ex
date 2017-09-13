defmodule ChatterWeb.UserController do
  use ChatterWeb, :controller

  alias Chatter.Repo
  alias Chatter.Chat.User


  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id})do
    user = Repo.get!(User, id)
    cond do
      user == Guardian.Plug.current_resource(conn) ->
        render(conn, "show.html", user: user)
      :error ->
        conn
        |> put_flash(:error, "No tienes permiso")
        |> redirect(to: user_path(conn, :index))
    end

  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.reg_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "usuario creado correctamente")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    cond do
      user == Guardian.Plug.current_resource(conn) ->
        changeset = User.changeset(user)
        render(conn, "edit.html", user: user, changeset: changeset)
      :error ->
        conn
        |> put_flash(:error, "No tienes permiso")
        |> redirect(to: user_path(conn, :index))
    end

  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.reg_changeset(user, user_params)
    cond do
      user == Guardian.Plug.current_resource(conn) ->
        case Repo.update(changeset) do
          {:ok, user} ->
            conn
            |> put_flash(:info, "Usuario se actualizo correctamente")
            |> redirect(to: user_path(conn, :show, user))
          {:error, changeset} ->
            render(conn, "edit.html", user: user, changeset: changeset)
        end
      :error ->
        conn
        |> put_flash(:error, "No tienes permiso")
        |> redirect(to: user_path(conn, :index))
    end

  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    cond do
      user == Guardian.Plug.current_resource(conn) ->
        Repo.delete!(user)
        conn
        |> Guardian.Plug.sign_out
        |> put_flash(:danger, "Usuario eliminado correctamente.")
        |> redirect(to: session_path(conn, :new))
      :error ->
        conn
        |> put_flash(:error, "No tienes permiso")
        |> redirect(to: user_path(conn, :index))
    end

  end

end
