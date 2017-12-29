defmodule Discuss.Plugs.SetUser do
  ##
  # The goal of this is to take the user_id out of session
  # data if a user is logged in and make a real user object
  # always available on the connection object.
  #
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Repo
  alias Discuss.User

  # a plug must have two functions. init is one of them
  def init(_params) do
  end

  # call is the other required function
  # params here are what is returned from the init function.
  # which in this case is nothing.
  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    # condition statement will execute the first thing
    # that returns true
    cond do
      user = user_id && Repo.get(User, user_id) ->
        assign(conn, :user, user) # assign() adds to the conn.assigns map.
      true ->
        assign(conn, :user, nil)
    end
  end
end
