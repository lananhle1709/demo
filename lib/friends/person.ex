defmodule Friends.Person do
  use Ecto.Schema
  schema "people" do
    field :name, :string
    field :year, :integer
  end

  def changeset(person, params \\ %{}) do
    person
    |> Ecto.Changeset.cast(params, [:name, :year])
    |> Ecto.Changeset.validate_required([:name, :year])
  end
end
