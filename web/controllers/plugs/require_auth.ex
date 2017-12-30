defmodule Discuss.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Router.Helpers

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn # continue if we have the user
    else
      conn
      |> put_flash(:error, "You must be logged in to do that")
      |> redirect(to: Helpers.topic_path(conn, :index))
      |> halt() # return here instead of continuing to controller
    end
  end
end
