defmodule Discuss.TopicController do
  # include controller functionality from base module at web/web.ex
  # this is basically how elixir/phoenix performs code sharing
  use Discuss.Web, :controller

  alias Discuss.Topic

  # run plug on these atoms
  plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:update, :edit, :delete] # this is a function plug local to this module

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    # this is cleaned up (i.e. not Discuss.Topic) because of the alias above
    changeset = Topic.changeset(%Topic{}, %{})

    # pass changeset into template as a keyword list
    render conn, "new.html", changeset: changeset
  end

  # pattern match the topic out right in the function args
  # dallins code: he removed the pattern match to make use of |> more
  # which is better, but it messed with the way my changeset is defined for now
  # def create(conn, params) do
  #   %Topic{}
  #   |> Topic.changeset(params)
  #   |> Repo.insert() # Repo is inserted from ecto through the :controller import at the top
  #   |> case do
  #     {:ok, _topic} ->
  #       conn
  #       |> put_flash(:info, "Topic Created")
  #       |> redirect(to: topic_path(conn, :index)) # send to topic controller and run index func.
  #     {:error, changeset} -> # show form again with error when failed
  #       render conn, "new.html", changeset: changeset
  #   end
  # end

  def create(conn, %{"topic" => topic}) do
    # changeset = Topic.changeset(%Topic{}, topic) # old code before association stuff

    changeset = conn.assigns.user
      |> build_assoc(:topics)
      |> Topic.changeset(topic)

    case Repo.insert(changeset) do # Repo is inserted from ecto through the :controller import at the top
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index)) # send to topic controller and run index func.
      {:error, changeset} -> # show form again with error when failed
        render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id) # crappy code
    changeset = Topic.changeset(old_topic, topic) # crappy code
    # changeset = Repo.get(Topic, topic_id) |> Topic.changeset(topic) # better but we loss ref to topic to pass into template on err :/

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} -> # changeset will have errors
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id) |> Repo.delete!

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: topic_path(conn, :index))
  end

  ##
  # A function plug
  #
  # The resources helper in routes.ex does some work behind the scenes to add
  # a topic's id to the conn map, which is what we'll use to check authorization
  #
  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn # gross code

    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You can't edit that")
      |> redirect(to: topic_path(conn, :index))
      |> halt()
    end
  end
end
