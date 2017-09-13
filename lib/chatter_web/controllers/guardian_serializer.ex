defmodule ChatterWeb.GuardianSerializer do
  alias Chatter.Repo
  alias Chatter.Chat.User

  def for_token(user = %User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Recurso desconocido"}

  def from_token("User:"<> id), do: {:ok, Repo.get(User, id)}
  def from_token(_), do: {:error, "Recurso desconocido"}
end
