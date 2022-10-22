defmodule N1gpWeb.TournmentLiveTest do
  use N1gpWeb.ConnCase

  import Phoenix.LiveViewTest
  import N1gp.TournmentsFixtures

  @create_attrs %{key: "some key", name: "some name", type: "some type"}
  @update_attrs %{key: "some updated key", name: "some updated name", type: "some updated type"}
  @invalid_attrs %{key: nil, name: nil, type: nil}

  defp create_tournment(_) do
    tournment = tournment_fixture()
    %{tournment: tournment}
  end

  describe "Index" do
    setup [:create_tournment]

    test "lists all tournments", %{conn: conn, tournment: tournment} do
      {:ok, _index_live, html} = live(conn, Routes.tournment_index_path(conn, :index))

      assert html =~ "Listing Tournments"
      assert html =~ tournment.key
    end

    test "saves new tournment", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.tournment_index_path(conn, :index))

      assert index_live |> element("a", "New Tournment") |> render_click() =~
               "New Tournment"

      assert_patch(index_live, Routes.tournment_index_path(conn, :new))

      assert index_live
             |> form("#tournment-form", tournment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#tournment-form", tournment: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.tournment_index_path(conn, :index))

      assert html =~ "Tournment created successfully"
      assert html =~ "some key"
    end

    test "updates tournment in listing", %{conn: conn, tournment: tournment} do
      {:ok, index_live, _html} = live(conn, Routes.tournment_index_path(conn, :index))

      assert index_live |> element("#tournment-#{tournment.id} a", "Edit") |> render_click() =~
               "Edit Tournment"

      assert_patch(index_live, Routes.tournment_index_path(conn, :edit, tournment))

      assert index_live
             |> form("#tournment-form", tournment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#tournment-form", tournment: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.tournment_index_path(conn, :index))

      assert html =~ "Tournment updated successfully"
      assert html =~ "some updated key"
    end

    test "deletes tournment in listing", %{conn: conn, tournment: tournment} do
      {:ok, index_live, _html} = live(conn, Routes.tournment_index_path(conn, :index))

      assert index_live |> element("#tournment-#{tournment.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tournment-#{tournment.id}")
    end
  end

  describe "Show" do
    setup [:create_tournment]

    test "displays tournment", %{conn: conn, tournment: tournment} do
      {:ok, _show_live, html} = live(conn, Routes.tournment_show_path(conn, :show, tournment))

      assert html =~ "Show Tournment"
      assert html =~ tournment.key
    end

    test "updates tournment within modal", %{conn: conn, tournment: tournment} do
      {:ok, show_live, _html} = live(conn, Routes.tournment_show_path(conn, :show, tournment))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Tournment"

      assert_patch(show_live, Routes.tournment_show_path(conn, :edit, tournment))

      assert show_live
             |> form("#tournment-form", tournment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#tournment-form", tournment: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.tournment_show_path(conn, :show, tournment))

      assert html =~ "Tournment updated successfully"
      assert html =~ "some updated key"
    end
  end
end
