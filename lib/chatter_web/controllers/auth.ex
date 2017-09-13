defmodule ChatterWeb.Auth do
  import Comeonin.Pbkdf2, only: [checkpw: 2, dummy_checkpw: 0]

  defp login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user, :access)
  end

  def login_with(conn, email, pass) do
    user = Chatter.Repo.get_by(Chatter.Chat.User, email: email)

    cond do
      user && checkpw(pass, user.encrypt_pass) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end
end
