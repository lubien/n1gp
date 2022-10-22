defmodule N1gpWeb.ChipLiveTest do
  use N1gpWeb.ConnCase

  import Phoenix.LiveViewTest
  import N1gp.ChipsFixtures

  @create_attrs %{aliases: [], atk: 42, codes: [], description: "some description", elements: [], image: "some image", mb: 42, more_details: [], name: "some name"}
  @update_attrs %{aliases: [], atk: 43, codes: [], description: "some updated description", elements: [], image: "some updated image", mb: 43, more_details: [], name: "some updated name"}
  @invalid_attrs %{aliases: [], atk: nil, codes: [], description: nil, elements: [], image: nil, mb: nil, more_details: [], name: nil}

  defp create_chip(_) do
    chip = chip_fixture()
    %{chip: chip}
  end

  describe "Index" do
    setup [:create_chip]

    test "lists all chips", %{conn: conn, chip: chip} do
      {:ok, _index_live, html} = live(conn, Routes.chip_index_path(conn, :index))

      assert html =~ "Listing Chips"
      assert html =~ chip.description
    end

    test "saves new chip", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.chip_index_path(conn, :index))

      assert index_live |> element("a", "New Chip") |> render_click() =~
               "New Chip"

      assert_patch(index_live, Routes.chip_index_path(conn, :new))

      assert index_live
             |> form("#chip-form", chip: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#chip-form", chip: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.chip_index_path(conn, :index))

      assert html =~ "Chip created successfully"
      assert html =~ "some description"
    end

    test "updates chip in listing", %{conn: conn, chip: chip} do
      {:ok, index_live, _html} = live(conn, Routes.chip_index_path(conn, :index))

      assert index_live |> element("#chip-#{chip.id} a", "Edit") |> render_click() =~
               "Edit Chip"

      assert_patch(index_live, Routes.chip_index_path(conn, :edit, chip))

      assert index_live
             |> form("#chip-form", chip: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#chip-form", chip: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.chip_index_path(conn, :index))

      assert html =~ "Chip updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes chip in listing", %{conn: conn, chip: chip} do
      {:ok, index_live, _html} = live(conn, Routes.chip_index_path(conn, :index))

      assert index_live |> element("#chip-#{chip.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#chip-#{chip.id}")
    end
  end

  describe "Show" do
    setup [:create_chip]

    test "displays chip", %{conn: conn, chip: chip} do
      {:ok, _show_live, html} = live(conn, Routes.chip_show_path(conn, :show, chip))

      assert html =~ "Show Chip"
      assert html =~ chip.description
    end

    test "updates chip within modal", %{conn: conn, chip: chip} do
      {:ok, show_live, _html} = live(conn, Routes.chip_show_path(conn, :show, chip))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Chip"

      assert_patch(show_live, Routes.chip_show_path(conn, :edit, chip))

      assert show_live
             |> form("#chip-form", chip: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#chip-form", chip: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.chip_show_path(conn, :show, chip))

      assert html =~ "Chip updated successfully"
      assert html =~ "some updated description"
    end
  end
end
