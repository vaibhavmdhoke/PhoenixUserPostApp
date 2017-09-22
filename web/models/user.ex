defmodule SimpleAuth.User do
  use SimpleAuth.Web, :model

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :is_admin, :boolean, default: false
    has_many :posts, SimpleAuth.Post

    timestamps()
  end

  @required_fields ~w(email password_hash)a
  @optional_fields ~w(name is_admin)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def registration_changeset(struct, params) do
    struct
    |> changeset(params)
    |> validate_length(:password_hash, min: 6, max: 100)
  end

end
