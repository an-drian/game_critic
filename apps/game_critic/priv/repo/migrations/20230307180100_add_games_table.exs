defmodule GameCritic.Repo.Migrations.AddGamesTable do
  use Ecto.Migration


  def up do
    execute("CREATE TYPE rating_categories AS ENUM ('everyone', 'everyone10', 'teen', 'mature17', 'adults18', 'pending', 'pending17')")

    create table(:games) do
      add(:name, :string, null: false)
      add(:release_date, :utc_datetime_usec, null: false)
      add(:raiting, :rating_categories, default: "pending")
      add(:description, :string, null: false)
      add(:img_url, :string)

      timestamps()
    end

    create unique_index(:games, [:name, :release_date], name: :name_and_release_index)
  end

  def down do
    drop_if_exists table(:games)
    execute("DROP TYPE IF EXISTS rating_categories")
  end
end
