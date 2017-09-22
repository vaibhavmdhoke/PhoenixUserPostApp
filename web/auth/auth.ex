defmodule SimpleAuth.Auth do
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias SimpleAuth.User
  alias SimpleAuth.Repo
  
  def login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
  end
  
  def login_by_email_and_pass(conn, email, given_pass) do
    user = Repo.get_by(SimpleAuth.User, email: email)
    # examine the result
    result = cond do
      # if user was found and provided password hash equals to stored
      # hash
      user && (given_pass == user.password_hash) ->
        {:ok, login(conn, user)}
      # else if we just found the use
      user ->
        {:error, :unauthorized , conn}
      # otherwise
      true ->
        # simulate check password hash timing
        dummy_checkpw
        {:error, :not_found, conn}
    end
  end
  
  def logout(conn) do
    Guardian.Plug.sign_out(conn)
  end

end
