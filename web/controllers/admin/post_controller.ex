defmodule SimpleAuth.Admin.PostController do
  use SimpleAuth.Web, :controller
  alias SimpleAuth.Post
  alias SimpleAuth.User

  def index(conn, %{"user_id" => user_id}, _current_user) do
    user = SimpleAuth.User |> Repo.get!(user_id)
    posts =
      user
      |> user_posts
      |> Repo.all
      |> Repo.preload(:user)
    render(conn, "index.html", posts: posts, user: user)
  end

   defp user_posts(user) do
    assoc(user, :posts)
  end

end