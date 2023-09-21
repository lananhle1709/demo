defmodule FriendsWeb.FriendsController do
  use FriendsWeb, :controller
  import Ecto.Query

  def list_all(conn, _params) do
    list_friends = Friends.Person |> Friends.Repo.all |> Helper.to_map()
    conn |> json(%{status: "OK", data: list_friends})
  end

  def get_info(conn, %{"name" => name}) do
    name = name |> String.replace("_", " ") |> IO.inspect
    infos = Ecto.Query.from(p in Friends.Person, where: fragment("UPPER(?) = UPPER(?)",p.name, ^name))
    |> Friends.Repo.all |> Helper.to_map
    conn |> json(%{status: "OK", data: infos})
  end
end
