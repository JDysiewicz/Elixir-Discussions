defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  alias Discuss.Discussions.Topic, as: Topic

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    case Discuss.Discussions.create_topic(topic) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def index(conn, _params) do
    topics = Discuss.Discussions.list_topics()
    render(conn, "index.html", topics: topics)
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Discuss.Discussions.get_topic!(topic_id)
    changeset = Topic.changeset(topic, %{})
    render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  def update(conn, %{"id" => topic_id, "topic" => updated_topic}) do
    curr_topic = Discuss.Discussions.get_topic!(topic_id)

    case Discuss.Discussions.update_topic(curr_topic, updated_topic) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Updated topic")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, topic: curr_topic)
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Discuss.Discussions.get_topic!(topic_id)
    |> Discuss.Discussions.delete_topic()

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: Routes.topic_path(conn, :index))
  end
end
