defmodule Discuss.Router do
  use Discuss.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Discuss.Plugs.SetUser # custom module plug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Discuss do
    pipe_through :browser # Use the default browser stack

    get "/", TopicController, :index

    # get "/", TopicController, :index
    # get "/topics/new", TopicController, :new
    # post "/topics", TopicController, :create
    # get "/topics", TopicController, :index
    # get "/topics/:id/edit", TopicController, :edit
    # put "/topics/:id", TopicController, :update

    # resources define all the above routes as a one-liner
    resources "/topics", TopicController
  end

  # OAuth routes
  scope "/auth", Discuss do
    pipe_through :browser
    get "/signout", AuthController, :signout # should be a delete request
    get "/:provider", AuthController, :request # <- defined by euberauth
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", Discuss do
  #   pipe_through :api
  # end
end
