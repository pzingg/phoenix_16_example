defmodule Example16Web.ProgressLiveTest do
  use Example16Web.ConnCase

  import Phoenix.LiveViewTest
  import Example16.WorkspaceFixtures

  @create_attrs %{
    completed: 42,
    description: "some description",
    status: "some status",
    total: 42
  }
  @update_attrs %{
    completed: 43,
    description: "some updated description",
    status: "some updated status",
    total: 43
  }
  @invalid_attrs %{completed: nil, description: nil, status: nil, total: nil}

  setup :set_time_zone_and_log_in_user

  defp create_progress(_) do
    progress = progress_fixture()
    %{progress: progress}
  end

  describe "Index" do
    setup [:create_progress]

    test "lists all progress", %{conn: conn, progress: progress} do
      {:ok, _index_live, html} = live(conn, Routes.progress_index_path(conn, :index))

      assert html =~ "Listing Progress"
      assert html =~ progress.description
    end

    test "saves new progress", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.progress_index_path(conn, :index))

      assert index_live |> element("a", "New Progress") |> render_click() =~
               "New Progress"

      assert_patch(index_live, Routes.progress_index_path(conn, :new))

      assert index_live
             |> form("#progress-form", progress: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#progress-form", progress: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.progress_index_path(conn, :index))

      assert html =~ "Progress created successfully"
      assert html =~ "some description"
    end

    test "updates progress in listing", %{conn: conn, progress: progress} do
      {:ok, index_live, _html} = live(conn, Routes.progress_index_path(conn, :index))

      assert index_live |> element("#progress-#{progress.id} a", "Edit") |> render_click() =~
               "Edit Progress"

      assert_patch(index_live, Routes.progress_index_path(conn, :edit, progress))

      assert index_live
             |> form("#progress-form", progress: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#progress-form", progress: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.progress_index_path(conn, :index))

      assert html =~ "Progress updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes progress in listing", %{conn: conn, progress: progress} do
      {:ok, index_live, _html} = live(conn, Routes.progress_index_path(conn, :index))

      assert index_live |> element("#progress-#{progress.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#progress-#{progress.id}")
    end
  end

  describe "Show" do
    setup [:create_progress]

    test "displays progress", %{conn: conn, progress: progress} do
      {:ok, _show_live, html} = live(conn, Routes.progress_show_path(conn, :show, progress))

      assert html =~ "Show Progress"
      assert html =~ progress.description
    end

    test "updates progress within modal", %{conn: conn, progress: progress} do
      {:ok, show_live, _html} = live(conn, Routes.progress_show_path(conn, :show, progress))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Progress"

      assert_patch(show_live, Routes.progress_show_path(conn, :edit, progress))

      assert show_live
             |> form("#progress-form", progress: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#progress-form", progress: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.progress_show_path(conn, :show, progress))

      assert html =~ "Progress updated successfully"
      assert html =~ "some updated description"
    end
  end
end
