defmodule Discuss.Topic do
  use Discuss.Web, :model

  schema "topics" do
    field :title, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end

  ## Below is dallins code
  # # @param {struct} struct :: represents a record in the db
  # # @param {map} params :: values we want to update our record with
  # def create_changeset(params \\ %{}) do # this is also how to do default values in elixir
  #   %__MODULE__{}
  #   |> cast(params, [:title]) # produces a changeset (a phoenix thing)
  #   |> validate_required([:title]) # adds errors to our changeset
  # end
  #
  # def update_changeset(%__MODULE__{} = struct, params \\ %{}) do # this is also how to do default values in elixir
  #   struct
  #   |> cast(params, [:title]) # produces a changeset (a phoenix thing)
  #   |> validate_required([:title]) # adds errors to our changeset
  # end
end
