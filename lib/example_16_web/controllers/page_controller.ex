defmodule Example16Web.PageController do
  use Example16Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
