defmodule ReWeb.Notifications.Emails.ServerTest do
  use Re.ModelCase

  import Re.Factory
  import Swoosh.TestAssertions

  alias Re.{
    Listing,
    Repo
  }

  alias ReWeb.Notifications.{
    Emails.Server,
    ReportEmail,
    UserEmail
  }

  describe "handle_cast/2" do
    test "notify_interest/1" do
      interest = insert(:interest, interest_type: build(:interest_type))
      Server.handle_cast({UserEmail, :notify_interest, [interest]}, [])
      interest = Repo.preload(interest, :interest_type)
      assert_email_sent(UserEmail.notify_interest(interest))
    end

    test "notify_interest/1 with online scheduling" do
      interest =
        insert(:interest, interest_type: build(:interest_type, name: "Agendamento online"))

      Server.handle_cast({UserEmail, :notify_interest, [interest]}, [])
      interest = Repo.preload(interest, :interest_type)
      email = UserEmail.notify_interest(interest)
      assert_email_sent(email)
      assert [{"", "contato@emcasa.com"}] == email.to
    end

    test "user_registered/1" do
      user = insert(:user)
      Server.handle_cast({UserEmail, :user_registered, [user]}, [])
      assert_email_sent(UserEmail.user_registered(user))
    end

    test "listing_added_admin/2" do
      user = insert(:user)
      listing = insert(:listing)
      Server.handle_cast({UserEmail, :listing_added_admin, [user, listing]}, [])
      assert_email_sent(UserEmail.listing_added_admin(user, listing))
    end

    test "listing_updated/2" do
      user = insert(:user)
      listing = insert(:listing, price: 950_000, rooms: 3)
      %{changes: changes} = Listing.changeset(listing, %{price: 1_000_000, rooms: 4}, "user")
      Server.handle_cast({UserEmail, :listing_updated, [user, listing, changes]}, [])
      assert_email_sent(UserEmail.listing_updated(user, listing, changes))
    end

    test "monthly_report/2" do
      user = insert(:user)

      listing1 =
        :listing
        |> build(user: user)
        |> Map.put(:listings_visualisations_count, 3)
        |> Map.put(:tour_visualisations_count, 2)
        |> Map.put(:in_person_visits_count, 4)
        |> Map.put(:listings_favorites_count, 5)
        |> Map.put(:interests_count, 8)

      listing2 =
        :listing
        |> build(user: user)
        |> Map.put(:listings_visualisations_count, 4)
        |> Map.put(:tour_visualisations_count, 12)
        |> Map.put(:in_person_visits_count, 4)
        |> Map.put(:listings_favorites_count, 3)
        |> Map.put(:interests_count, 0)

      Server.handle_cast({ReportEmail, :monthly_report, [user, [listing1, listing2]]}, [])
      assert_email_sent(ReportEmail.monthly_report(user, [listing1, listing2]))
    end
  end

  describe "handle_info/2" do
    test "contact requested by anonymous" do
      %{id: id} =
        insert(
          :contact_request,
          name: "mahname",
          email: "mahemail@emcasa.com",
          phone: "123321123",
          message: "cool website"
        )

      Server.handle_info(
        %Phoenix.Socket.Broadcast{
          payload: %{result: %{data: %{"contactRequested" => %{"id" => id}}}}
        },
        []
      )

      assert_email_sent(
        UserEmail.contact_request(%{
          name: "mahname",
          email: "mahemail@emcasa.com",
          phone: "123321123",
          message: "cool website"
        })
      )
    end

    test "contact requested by user" do
      user = insert(:user)
      %{id: id} = insert(:contact_request, message: "cool website", user: user)

      Server.handle_info(
        %Phoenix.Socket.Broadcast{
          payload: %{result: %{data: %{"contactRequested" => %{"id" => id}}}}
        },
        []
      )

      assert_email_sent(
        UserEmail.contact_request(%{
          name: user.name,
          email: user.email,
          phone: user.phone,
          message: "cool website"
        })
      )
    end

    test "contact requested by user with new email" do
      user = insert(:user)

      %{id: id} =
        insert(
          :contact_request,
          message: "cool website",
          user: user,
          email: "different@email.com"
        )

      Server.handle_info(
        %Phoenix.Socket.Broadcast{
          payload: %{result: %{data: %{"contactRequested" => %{"id" => id}}}}
        },
        []
      )

      assert_email_sent(
        UserEmail.contact_request(%{
          name: user.name,
          email: "different@email.com",
          phone: user.phone,
          message: "cool website"
        })
      )
    end

    test "price suggestion requested when price" do
      address = insert(:address)
      %{id: id} = request = insert(:price_suggestion_request, address: address, is_covered: false)

      Server.handle_info(
        %Phoenix.Socket.Broadcast{
          payload: %{
            result: %{
              data: %{"priceSuggestionRequested" => %{"id" => id, "suggestedPrice" => 10.10}}
            }
          }
        },
        []
      )

      assert_email_sent(
        UserEmail.price_suggestion_requested(
          %{
            name: request.name,
            email: request.email,
            area: request.area,
            rooms: request.rooms,
            bathrooms: request.bathrooms,
            garage_spots: request.garage_spots,
            address: %{
              street: address.street,
              street_number: address.street_number
            },
            is_covered: false
          },
          10.10
        )
      )
    end

    test "price suggestion requested for not covered street" do
      address = insert(:address)
      %{id: id} = request = insert(:price_suggestion_request, address: address, is_covered: true)

      Server.handle_info(
        %Phoenix.Socket.Broadcast{
          payload: %{
            result: %{
              data: %{"priceSuggestionRequested" => %{"id" => id, "suggestedPrice" => nil}}
            }
          }
        },
        []
      )

      assert_email_sent(
        UserEmail.price_suggestion_requested(
          %{
            name: request.name,
            email: request.email,
            area: request.area,
            rooms: request.rooms,
            bathrooms: request.bathrooms,
            garage_spots: request.garage_spots,
            address: %{
              street: address.street,
              street_number: address.street_number
            },
            is_covered: true
          },
          nil
        )
      )
    end
  end
end
