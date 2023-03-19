require "test_helper"

class CleanedVideosControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_cleaned_video_url
    assert_response :success
  end

  test "should render new with 422 if url is invalid" do
    # post an invalid url
    post cleaned_videos_url, params: { cleaned_video: { video_url: "https://www.example.com" } }
    assert_response :unprocessable_entity
  end

  test "should be successful if url is valid" do
    # don't make actual http requests
    VideoIdFromUrl.any_instance.expects(:get_id).returns("12345")

    httparty = mock()
    httparty.expects(:body).returns(File.read(Rails.root.join('test', 'data', 'video_data.json')))
  
    TikTokMetaApi.any_instance.expects(:video_data).with("12345").returns(httparty)
    
    post cleaned_videos_url(format: :turobo_stream), 
      params: { cleaned_video: { video_url: "https://www.tiktok.com/@tiktok/video/12345" } }

    assert_response :success
  end
end
