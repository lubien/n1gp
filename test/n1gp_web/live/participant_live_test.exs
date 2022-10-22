defmodule N1gpWeb.ParticipantLiveTest do
  use N1gpWeb.ConnCase

  import Phoenix.LiveViewTest
  import N1gp.TournmentsFixtures

  @create_attrs %{discord_name: "some discord_name", entrant_no: 42, name: "some name", navicust: [], navicust_image: "some navicust_image", version: "some version"}
  @update_attrs %{discord_name: "some updated discord_name", entrant_no: 43, name: "some updated name", navicust: [], navicust_image: "some updated navicust_image", version: "some updated version"}
  @invalid_attrs %{discord_name: nil, entrant_no: nil, name: nil, navicust: [], navicust_image: nil, version: nil}

  defp create_participant(_) do
    participant = participant_fixture()
    %{participant: participant}
  end

  describe "Index" do
    setup [:create_participant]

    test "lists all participants", %{conn: conn, participant: participant} do
      {:ok, _index_live, html} = live(conn, Routes.participant_index_path(conn, :index))

      assert html =~ "Listing Participants"
      assert html =~ participant.discord_name
    end

    test "saves new participant", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.participant_index_path(conn, :index))

      assert index_live |> element("a", "New Participant") |> render_click() =~
               "New Participant"

      assert_patch(index_live, Routes.participant_index_path(conn, :new))

      assert index_live
             |> form("#participant-form", participant: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#participant-form", participant: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.participant_index_path(conn, :index))

      assert html =~ "Participant created successfully"
      assert html =~ "some discord_name"
    end

    test "updates participant in listing", %{conn: conn, participant: participant} do
      {:ok, index_live, _html} = live(conn, Routes.participant_index_path(conn, :index))

      assert index_live |> element("#participant-#{participant.id} a", "Edit") |> render_click() =~
               "Edit Participant"

      assert_patch(index_live, Routes.participant_index_path(conn, :edit, participant))

      assert index_live
             |> form("#participant-form", participant: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#participant-form", participant: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.participant_index_path(conn, :index))

      assert html =~ "Participant updated successfully"
      assert html =~ "some updated discord_name"
    end

    test "deletes participant in listing", %{conn: conn, participant: participant} do
      {:ok, index_live, _html} = live(conn, Routes.participant_index_path(conn, :index))

      assert index_live |> element("#participant-#{participant.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#participant-#{participant.id}")
    end
  end

  describe "Show" do
    setup [:create_participant]

    test "displays participant", %{conn: conn, participant: participant} do
      {:ok, _show_live, html} = live(conn, Routes.participant_show_path(conn, :show, participant))

      assert html =~ "Show Participant"
      assert html =~ participant.discord_name
    end

    test "updates participant within modal", %{conn: conn, participant: participant} do
      {:ok, show_live, _html} = live(conn, Routes.participant_show_path(conn, :show, participant))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Participant"

      assert_patch(show_live, Routes.participant_show_path(conn, :edit, participant))

      assert show_live
             |> form("#participant-form", participant: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#participant-form", participant: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.participant_show_path(conn, :show, participant))

      assert html =~ "Participant updated successfully"
      assert html =~ "some updated discord_name"
    end
  end
end
