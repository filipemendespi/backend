defmodule Re.Exporters.FacebookAdsTest do
  use Re.ModelCase

  alias Re.{
    Exporters.FacebookAds,
    Image,
    Address,
    Listing
  }

  @frontend_url Application.get_env(:re_integrations, :frontend_url)
  @image_url "https://res.cloudinary.com/emcasa/image/upload/f_auto/v1513818385"

  describe "build_node/2" do
    test "export XML including listing first image" do
      listing = %Listing{
        id: 7_004_578,
        price: 800,
        type: "Apartamento",
        area: 300,
        rooms: 4,
        bathrooms: 4,
        description:
          "Sobrado, 4 dormitórios, 3 suites, 4 vagas de garagem, 2 salas , 1 lavabo, 1 banheiro, área de serviço",
        address: %Address{
          street: "Rua do Ipiranga",
          street_number: 20,
          neighborhood: "Ipiranga",
          city: "São Paulo",
          state: "SP",
          postal_code: "04732-192",
          lat: 51.496401,
          lng: -0.179
        },
        matterport_code: "mY123",
        images: [
          %Image{
            filename: "living_room.png",
            description: "Living room"
          },
          %Image{
            filename: "suite_1.png",
            description: nil
          }
        ]
      }

      expected_xml =
        "<listing>" <>
          "<home_listing_id><![CDATA[7004578]]></home_listing_id>" <>
          "<url><![CDATA[#{@frontend_url}/imoveis/7004578]]></url>" <>
          "<name><![CDATA[Apartamento a venda em São Paulo]]></name>" <>
          "<availability><![CDATA[for_sale]]></availability>" <>
          "<description><![CDATA[Sobrado, 4 dormitórios, 3 suites, 4 vagas de garagem, 2 salas , 1 lavabo, 1 banheiro, área de serviço]]></description>" <>
          "<price><![CDATA[800 BRL]]></price>" <>
          "<property_type><![CDATA[apartment]]></property_type>" <>
          "<num_beds><![CDATA[4]]></num_beds>" <>
          "<num_baths><![CDATA[4]]></num_baths>" <>
          "<num_units><![CDATA[1]]></num_units>" <>
          "<area_unit><![CDATA[sq_m]]></area_unit>" <>
          "<area_size><![CDATA[300]]></area_size>" <>
          "<address format=\"simple\">" <>
          "<component name=\"addr1\"><![CDATA[Rua do Ipiranga]]></component>" <>
          "<component name=\"city\"><![CDATA[São Paulo]]></component>" <>
          "<component name=\"region\"><![CDATA[Ipiranga]]></component>" <>
          "<component name=\"country\"><![CDATA[Brazil]]></component>" <>
          "<component name=\"postal_code\"><![CDATA[04732-192]]></component>" <>
          "</address>" <>
          "<latitude><![CDATA[51.496401]]></latitude>" <>
          "<longitude><![CDATA[-0.179]]></longitude>" <>
          "<image>" <>
          "<url><![CDATA[#{@image_url}/living_room.png]]></url>" <> "</image>" <> "</listing>"

      generated_xml =
        listing
        |> FacebookAds.build_node(FacebookAds.merge_default_options(%{}))
        |> XmlBuilder.generate(format: :none)

      assert expected_xml == generated_xml
    end

    test "export XML without images from listing" do
      listing = %Listing{
        id: 7_004_578,
        price: 800,
        type: "Apartamento",
        area: 300,
        rooms: 4,
        bathrooms: 4,
        description:
          "Sobrado, 4 dormitórios, 3 suites, 4 vagas de garagem, 2 salas , 1 lavabo, 1 banheiro, área de serviço",
        address: %Address{
          street: "Rua do Ipiranga",
          street_number: 20,
          neighborhood: "Ipiranga",
          city: "São Paulo",
          state: "SP",
          postal_code: "04732-192",
          lat: 51.496401,
          lng: -0.179
        },
        images: []
      }

      expected_xml =
        "<listing>" <>
          "<home_listing_id><![CDATA[7004578]]></home_listing_id>" <>
          "<url><![CDATA[#{@frontend_url}/imoveis/7004578]]></url>" <>
          "<name><![CDATA[Apartamento a venda em São Paulo]]></name>" <>
          "<availability><![CDATA[for_sale]]></availability>" <>
          "<description><![CDATA[Sobrado, 4 dormitórios, 3 suites, 4 vagas de garagem, 2 salas , 1 lavabo, 1 banheiro, área de serviço]]></description>" <>
          "<price><![CDATA[800 BRL]]></price>" <>
          "<property_type><![CDATA[apartment]]></property_type>" <>
          "<num_beds><![CDATA[4]]></num_beds>" <>
          "<num_baths><![CDATA[4]]></num_baths>" <>
          "<num_units><![CDATA[1]]></num_units>" <>
          "<area_unit><![CDATA[sq_m]]></area_unit>" <>
          "<area_size><![CDATA[300]]></area_size>" <>
          "<address format=\"simple\">" <>
          "<component name=\"addr1\"><![CDATA[Rua do Ipiranga]]></component>" <>
          "<component name=\"city\"><![CDATA[São Paulo]]></component>" <>
          "<component name=\"region\"><![CDATA[Ipiranga]]></component>" <>
          "<component name=\"country\"><![CDATA[Brazil]]></component>" <>
          "<component name=\"postal_code\"><![CDATA[04732-192]]></component>" <>
          "</address>" <>
          "<latitude><![CDATA[51.496401]]></latitude>" <>
          "<longitude><![CDATA[-0.179]]></longitude>" <> "<image/>" <> "</listing>"

      generated_xml =
        listing
        |> FacebookAds.build_node(FacebookAds.merge_default_options(%{}))
        |> XmlBuilder.generate(format: :none)

      assert expected_xml == generated_xml
    end

    test "export XML without rooms/bathroms from listing" do
      listing = %Listing{
        id: 7_004_578,
        price: 800,
        type: "Apartamento",
        area: 300,
        rooms: nil,
        bathrooms: nil,
        description:
          "Sobrado, 4 dormitórios, 3 suites, 4 vagas de garagem, 2 salas , 1 lavabo, 1 banheiro, área de serviço",
        address: %Address{
          street: "Rua do Ipiranga",
          street_number: 20,
          neighborhood: "Ipiranga",
          city: "São Paulo",
          state: "SP",
          postal_code: "04732-192",
          lat: 51.496401,
          lng: -0.179
        },
        images: []
      }

      expected_xml =
        "<listing>" <>
          "<home_listing_id><![CDATA[7004578]]></home_listing_id>" <>
          "<url><![CDATA[#{@frontend_url}/imoveis/7004578]]></url>" <>
          "<name><![CDATA[Apartamento a venda em São Paulo]]></name>" <>
          "<availability><![CDATA[for_sale]]></availability>" <>
          "<description><![CDATA[Sobrado, 4 dormitórios, 3 suites, 4 vagas de garagem, 2 salas , 1 lavabo, 1 banheiro, área de serviço]]></description>" <>
          "<price><![CDATA[800 BRL]]></price>" <>
          "<property_type><![CDATA[apartment]]></property_type>" <>
          "<num_beds><![CDATA[0]]></num_beds>" <>
          "<num_baths><![CDATA[0]]></num_baths>" <>
          "<num_units><![CDATA[1]]></num_units>" <>
          "<area_unit><![CDATA[sq_m]]></area_unit>" <>
          "<area_size><![CDATA[300]]></area_size>" <>
          "<address format=\"simple\">" <>
          "<component name=\"addr1\"><![CDATA[Rua do Ipiranga]]></component>" <>
          "<component name=\"city\"><![CDATA[São Paulo]]></component>" <>
          "<component name=\"region\"><![CDATA[Ipiranga]]></component>" <>
          "<component name=\"country\"><![CDATA[Brazil]]></component>" <>
          "<component name=\"postal_code\"><![CDATA[04732-192]]></component>" <>
          "</address>" <>
          "<latitude><![CDATA[51.496401]]></latitude>" <>
          "<longitude><![CDATA[-0.179]]></longitude>" <> "<image/>" <> "</listing>"

      generated_xml =
        listing
        |> FacebookAds.build_node(FacebookAds.merge_default_options(%{}))
        |> XmlBuilder.generate(format: :none)

      assert expected_xml == generated_xml
    end
  end

  describe "export_listing/1" do
    test "export listing with proper root node" do
      expected_xml =
        ~s|<?xml version="1.0" encoding="UTF-8"?>| <>
          "<listings><listing><home_listing_id><![CDATA[1]]></home_listing_id></listing></listings>"

      generated_xml = FacebookAds.export_listings_xml([%Listing{id: 1}], %{attributes: [:id]})

      assert expected_xml == generated_xml
    end
  end
end
