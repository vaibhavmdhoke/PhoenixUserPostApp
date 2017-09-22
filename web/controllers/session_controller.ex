defmodule SimpleAuth.SessionController do
  use SimpleAuth.Web, :controller
  plug :scrub_params, "session" when action in ~w(create)a
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]


  def new(conn, _) do
    render conn, "new.html"
  end
  
  def create(conn, %{"session" => %{"email" => email,
                                    "password_hash" => password}}) do# try to get user by unique email from DB

    case SimpleAuth.Auth.login_by_email_and_pass(conn, email,
                                                 password) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "You’re now logged in!")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end
  end

  defp login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
  end

  def delete(conn, _) do
    conn
    |> SimpleAuth.Auth.logout
    |> put_flash(:info, "See you later!")
    |> redirect(to: page_path(conn, :index))
  end

 

end
