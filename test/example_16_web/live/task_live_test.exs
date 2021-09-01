defmodule Example16Web.TaskLiveTest do
  use Example16Web.ConnCase

  import Phoenix.LiveViewTest
  import Example16.WorkspaceFixtures

  setup :register_and_log_in_user

  @create_attrs %{cancelled_at: %{day: 31, hour: 19, minute: 29, month: 8, year: 2021}, completed_at: %{day: 31, hour: 19, minute: 29, month: 8, year: 2021}, description: "some description", generation: 42, started_at: %{day: 31, hour: 19, minute: 29, month: 8, year: 2021}, status: "some status", type: "some type"}
  @update_attrs %{cancelled_at: %{day: 1, hour: 19, minute: 29, month: 9, year: 2021}, completed_at: %{day: 1, hour: 19, minute: 29, month: 9, year: 2021}, description: "some updated description", generation: 43, started_at: %{day: 1, hour: 19, minute: 29, month: 9, year: 2021}, status: "some updated status", type: "some updated type"}
  @invalid_attrs %{cancelled_at: %{day: 30, hour: 19, minute: 29, month: 2, year: 2021}, completed_at: %{day: 30, hour: 19, minute: 29, month: 2, year: 2021}, description: nil, generation: nil, started_at: %{day: 30, hour: 19, minute: 29, month: 2, year: 2021}, status: nil, type: nil}

  defp create_task(_) do
    task = task_fixture()
    %{task: task}
  end

  describe "Index" do
    setup [:create_task]

    test "lists all tasks", %{conn: conn, task: task} do
      {:ok, _index_live, html} = live(conn, Routes.task_index_path(conn, :index))

      assert html =~ "Listing Tasks"
      assert html =~ task.description
    end

    test "saves new task", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      assert index_live |> element("a", "New Task") |> render_click() =~
               "New Task"

      assert_patch(index_live, Routes.task_index_path(conn, :new))

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#task-form", task: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.task_index_path(conn, :index))

      assert html =~ "Task created successfully"
      assert html =~ "some description"
    end

    test "updates task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      assert index_live |> element("#task-#{task.id} a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(index_live, Routes.task_index_path(conn, :edit, task))

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#task-form", task: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.task_index_path(conn, :index))

      assert html =~ "Task updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      assert index_live |> element("#task-#{task.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#task-#{task.id}")
    end
  end

  describe "Show" do
    setup [:create_task]

    test "displays task", %{conn: conn, task: task} do
      {:ok, _show_live, html} = live(conn, Routes.task_show_path(conn, :show, task))

      assert html =~ "Show Task"
      assert html =~ task.description
    end

    test "updates task within modal", %{conn: conn, task: task} do
      {:ok, show_live, _html} = live(conn, Routes.task_show_path(conn, :show, task))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(show_live, Routes.task_show_path(conn, :edit, task))

      assert show_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#task-form", task: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.task_show_path(conn, :show, task))

      assert html =~ "Task updated successfully"
      assert html =~ "some updated description"
    end
  end
end
