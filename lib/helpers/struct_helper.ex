defmodule Helper do
  require Decimal

  def to_map(structs) when is_list(structs) do
    Enum.map(structs, &to_map/1)
  end

  def to_map(struct) when is_struct(struct) do
    struct
    |> Map.from_struct()
    |> to_map()
  end

  def to_map(map) when is_map(map) do
    map
    |> Enum.filter(fn
      # Skip association not loaded field
      {:__meta__, _value} -> false
      {_k, %Ecto.Association.NotLoaded{}} -> false
      _ -> true
    end)
    |> Enum.into(%{}, fn
      {key, %{__struct__: struct} = value} when struct in [Date, Time] ->
        {key, value}

      {key, %{__struct__: struct} = value} when struct in [DateTime] ->
        {key, Utils.DateTime.local_default(value)}

      {key, %{__struct__: struct} = value} when struct in [NaiveDateTime] ->
        {key, value |> DateTime.from_naive!("Etc/UTC") |> Utils.DateTime.local_default()}

      {key, values} when Decimal.is_decimal(values) ->
        {key, values}

      {key, %MapSet{map: map}} ->
        {key, Map.keys(map)}

      {key, values} when is_list(values) ->
        {key, to_map(values)}

      {key, value} when is_map(value) ->
        {key, to_map(value)}

      {key, value} ->
        {key, value}
    end)
  end

  def to_map(term) do
    term
  end

  def serialize(user) do
    case user do
      %{} ->
        Map.take(user, [:id, :full_name, :email])

      _ ->
        user
    end
  end

  def to_db_map(structs) when is_list(structs) do
    Enum.map(structs, &to_db_map/1)
  end

  def to_db_map(struct) when is_struct(struct) do
    struct
    |> Map.from_struct()
    |> to_db_map()
  end

  def to_db_map(map) when is_map(map) do
    map
    |> Enum.filter(fn
      # Skip association not loaded field
      {:__meta__, _value} -> false
      {_k, %Ecto.Association.NotLoaded{}} -> false
      _ -> true
    end)
    |> Enum.into(%{}, & &1)
  end
end
