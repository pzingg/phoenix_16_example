defmodule Example16Web.ProjectLiveTest do
  use Example16Web.ConnCase

  import Phoenix.LiveViewTest
  import Example16.WorkspaceFixtures

  @create_attrs %{
    completed?: true,
    description: "some description",
    design_cost: "120.5",
    generation: 42,
    name: "some name",
    remaining: 42,
    type: "some type"
  }
  @update_attrs %{
    completed?: false,
    description: "some updated description",
    design_cost: "456.7",
    generation: 43,
    name: "some updated name",
    remaining: 43,
    type: "some updated type"
  }
  @invalid_attrs %{
    completed?: false,
    description: nil,
    design_cost: nil,
    generation: nil,
    name: nil,
    remaining: nil,
    type: nil
  }

  setup :set_time_zone_and_log_in_user

  defp create_project(_) do
    project = project_fixture()
    %{project: project}
  end

  describe "Index" do
    setup [:create_project]

    test "lists all projects", %{conn: conn, project: project} do
      {:ok, _index_live, html} = live(conn, Routes.project_index_path(conn, :index))

      assert html =~ "Listing Projects"
      assert html =~ project.description
    end

    test "saves new project", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.project_index_path(conn, :index))

      assert index_live |> element("a", "New Project") |> render_click() =~
               "New Project"

      assert_patch(index_live, Routes.project_index_path(conn, :new))

      assert index_live
             |> form("#project-form", project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#project-form", project: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.project_index_path(conn, :index))

      assert html =~ "Project created successfully"
      assert html =~ "some description"
    end

    test "updates project in listing", %{conn: conn, project: project} do
      {:ok, index_live, _html} = live(conn, Routes.project_index_path(conn, :index))

      assert index_live |> element("#project-#{project.id} a", "Edit") |> render_click() =~
               "Edit Project"

      assert_patch(index_live, Routes.project_index_path(conn, :edit, project))

      assert index_live
             |> form("#project-form", project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#project-form", project: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.project_index_path(conn, :index))

      assert html =~ "Project updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes project in listing", %{conn: conn, project: project} do
      {:ok, index_live, _html} = live(conn, Routes.project_index_path(conn, :index))

      assert index_live |> element("#project-#{project.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#project-#{project.id}")
    end
  end

  describe "Show" do
    setup [:create_project]

    test "displays project", %{conn: conn, project: project} do
      {:ok, _show_live, html} = live(conn, Routes.project_show_path(conn, :show, project))

      assert html =~ "Show Project"
      assert html =~ project.description
    end

    test "updates project within modal", %{conn: conn, project: project} do
      {:ok, show_live, _html} = live(conn, Routes.project_show_path(conn, :show, project))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Project"

      assert_patch(show_live, Routes.project_show_path(conn, :edit, project))

      assert show_live
             |> form("#project-form", project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#project-form", project: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.project_show_path(conn, :show, project))

      assert html =~ "Project updated successfully"
      assert html =~ "some updated description"
    end
  end
end
