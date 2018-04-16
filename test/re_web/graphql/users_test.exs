defmodule ReWeb.GraphQL.UsersTest do
  use ReWeb.ConnCase

  import Re.Factory

  alias ReWeb.AbsintheHelpers

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")
    admin_user = insert(:user, email: "admin@email.com", role: "admin")
    user_user = insert(:user, email: "user@email.com", role: "user")

    {:ok,
     unauthenticated_conn: conn,
     admin_user: admin_user,
     user_user: user_user,
     admin_conn: login_as(conn, admin_user),
     user_conn: login_as(conn, user_user)}
  end

  describe "activateListing" do
    test "admin should get favorited listings", %{admin_conn: conn, admin_user: user} do
      listing = insert(:listing)
      insert(:listing_favorite, listing_id: listing.id, user_id: user.id)

      query = """
        {
          favoritedListings {
            id
          }
        }
      """

      conn =
        post(conn, "/graphql_api", AbsintheHelpers.query_skeleton(query, "favoritedListings"))

      listing_id = to_string(listing.id)
      assert %{"favoritedListings" => [%{"id" => ^listing_id}]} = json_response(conn, 200)["data"]
    end

    test "user should get favorited listings", %{user_conn: conn, user_user: user} do
      listing = insert(:listing)
      insert(:listing_favorite, listing_id: listing.id, user_id: user.id)

      query = """
        {
          favoritedListings {
            id
          }
        }
      """

      conn =
        post(conn, "/graphql_api", AbsintheHelpers.query_skeleton(query, "favoritedListings"))

      listing_id = to_string(listing.id)
      assert %{"favoritedListings" => [%{"id" => ^listing_id}]} = json_response(conn, 200)["data"]
    end

    test "anonymous should not get favorited listing", %{unauthenticated_conn: conn} do
      query = """
        {
          favoritedListings {
            id
          }
        }
      """

      conn =
        post(conn, "/graphql_api", AbsintheHelpers.query_skeleton(query, "favoritedListings"))

      assert [%{"message" => "unauthorized"}] = json_response(conn, 200)["errors"]
    end
  end
end