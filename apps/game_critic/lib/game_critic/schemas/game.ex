defmodule GameCritic.Schemas.Game do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "games" do
    field(:name, :string)
    field(:release_date, :utc_datetime_usec)

    field(:raiting, Ecto.Enum,
      values: [:everyone, :everyone10, :teen, :mature17, :adults18, :pending, :pending17],
      default: :pending
    )

    field(:description, :string)
    field(:img_url, :string)
  end

  @required_fields [:name, :release_date, :raiting, :description]
  @optional_fields [:img_url]

  def changeset(model, params) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:name_and_release_date, name: :name_and_release_index)
  end
end
