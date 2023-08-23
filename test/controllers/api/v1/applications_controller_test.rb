require "controllers/api/v1/test"

class Api::V1::ApplicationsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @application = build(:application, team: @team)
    @other_applications = create_list(:application, 3)

    @another_application = create(:application, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @application.save
    @another_application.save
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(application_data)
    # Fetch the application in question and prepare to compare it's attributes.
    application = Application.find(application_data["id"])

    assert_equal_or_nil application_data['name'], application.name
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal application_data["team_id"], application.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/applications", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    application_ids_returned = response.parsed_body.map { |application| application["id"] }
    assert_includes(application_ids_returned, @application.id)

    # But not returning other people's resources.
    assert_not_includes(application_ids_returned, @other_applications[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/applications/#{@application.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/applications/#{@application.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    application_data = JSON.parse(build(:application, team: nil).to_api_json.to_json)
    application_data.except!("id", "team_id", "created_at", "updated_at")
    params[:application] = application_data

    post "/api/v1/teams/#{@team.id}/applications", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/applications",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/applications/#{@application.id}", params: {
      access_token: access_token,
      application: {
        name: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @application.reload
    assert_equal @application.name, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/applications/#{@application.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Application.count", -1) do
      delete "/api/v1/applications/#{@application.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/applications/#{@another_application.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
