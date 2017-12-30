defmodule Discuss.User do
  use Discuss.Web, :model

  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    has_many :topics, Discuss.Topic

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :provider, :token])
    |> validate_required([:email, :provider, :token])
  end

  ## Below is dallins code

  # @required_fields ~w(
  #   email
  #   provider
  #   token
  # )a
  #
  # @allowed_fields @required_fields ++ ~w()
  #
  # ##
  # # changeset used to create new users
  # #
  # # @param {struct} :: represents a record in the db
  # # @param {map} :: values with which we want to update our struct
  # #
  # def changeset(struct, params \\ %{}) do
  #   struct
  #   |> cast(params, @allowed_fields)
  #   |> validate_required(@required_fields)
  # end
end
