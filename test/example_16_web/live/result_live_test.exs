defmodule Example16Web.ResultLiveTest do
  use Example16Web.ConnCase

  import Phoenix.LiveViewTest
  import Example16.WorkspaceFixtures

  setup :set_time_zone_and_log_in_user

  @errors Jason.encode!(
            %{
              "0": %{
                message: "some message",
                path: "some path",
                phase: "some phase",
                system: false,
                fatal: true
              }
            },
            pretty: true
          )

  @create_attrs %{
    data: "",
    description: "some description",
    errors: @errors,
    generation: 42,
    type: "some type"
  }
  @update_attrs %{
    data: "",
    description: "some updated description",
    errors: @errors,
    generation: 43,
    type: "some updated type"
  }
  @invalid_attrs %{data: nil, description: nil, errors: nil, generation: nil, type: nil}

  defp create_result(_) do
    result = result_fixture()
    %{result: result}
  end

  describe "Index" do
    setup [:create_result]

    test "lists all results", %{conn: conn, result: result} do
      {:ok, _index_live, html} = live(conn, Routes.result_index_path(conn, :index))

      assert html =~ "Listing Results"
      assert html =~ result.description
    end

    test "saves new result", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.result_index_path(conn, :index))

      assert index_live |> element("a", "New Result") |> render_click() =~
               "New Result"

      assert_patch(index_live, Routes.result_index_path(conn, :new))

      assert index_live
             |> form("#result-form", result: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#result-form", result: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.result_index_path(conn, :index))

      assert html =~ "Result created successfully"
      assert html =~ "some description"
    end

    test "updates result in listing", %{conn: conn, result: result} do
      {:ok, index_live, _html} = live(conn, Routes.result_index_path(conn, :index))

      assert index_live |> element("#result-#{result.id} a", "Edit") |> render_click() =~
               "Edit Result"

      assert_patch(index_live, Routes.result_index_path(conn, :edit, result))

      assert index_live
             |> form("#result-form", result: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#result-form", result: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.result_index_path(conn, :index))

      assert html =~ "Result updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes result in listing", %{conn: conn, result: result} do
      {:ok, index_live, _html} = live(conn, Routes.result_index_path(conn, :index))

      assert index_live |> element("#result-#{result.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#result-#{result.id}")
    end
  end

  describe "Show" do
    setup [:create_result]

    test "displays result", %{conn: conn, result: result} do
      {:ok, _show_live, html} = live(conn, Routes.result_show_path(conn, :show, result))

      assert html =~ "Show Result"
      assert html =~ result.description
    end

    test "updates result within modal", %{conn: conn, result: result} do
      {:ok, show_live, _html} = live(conn, Routes.result_show_path(conn, :show, result))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Result"

      assert_patch(show_live, Routes.result_show_path(conn, :edit, result))

      assert show_live
             |> form("#result-form", result: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#result-form", result: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.result_show_path(conn, :show, result))

      assert html =~ "Result updated successfully"
      assert html =~ "some updated description"
    end
  end
end
