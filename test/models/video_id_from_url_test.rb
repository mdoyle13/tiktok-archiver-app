require 'test_helper'

class VideoIdFromUrlTest < ActiveSupport::TestCase
  test "should be invalid without a video_url" do
    video = VideoIdFromUrl.new
    assert_not video.valid?
  end

  test "should be invalid if video_url is not in the correct format" do
    video = VideoIdFromUrl.new(video_url: "https://example.com/foo?bar=baz")
    assert_not video.valid?
  end

  test "should be valid if video url is normalized" do
    video = VideoIdFromUrl.new(video_url: "https://www.tiktok.com/@username/video/12345?is_from_webapp=1&sender_device=pc")
    assert video.valid?
  end

  test "should be valid if video url is not normalized" do
    video = VideoIdFromUrl.new(video_url: "https://www.tiktok.com/t/12345/")
    assert video.valid?
  end
end