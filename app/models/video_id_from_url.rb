# frozen_string_literal: true

class VideoIdFromUrl

  # given a url in either this format 
  # https://www.tiktok.com/@tadeusofficial/video/{id}?is_from_webapp=1&sender_device=pc 
  # or https://www.tiktok.com/t/{id}/

  include ActiveModel::Model

  BASE_URL_FMT = /^https?:\/\/www\.tiktok\.com\/@\w+\/video\/\d+\??[^\s]*$/.freeze
  REDIRECT_URL_FMT = /^https?:\/\/www\.tiktok\.com\/t\/\w+\/?$/.freeze
  ID_REGEX = /\/video\/(\d+)/.freeze

  attr_accessor :video_url, :video_id

  validates :video_url, presence: true
  validate :valid_url_format

  def get_id
    return nil unless valid?
  
    self.video_id = normalized_url.match(ID_REGEX)[1]
  end

  private

  def valid_url_format
    return unless video_url.present?

    # check if the url is valid url and that it matches the formats we want
    unless video_url.match(/\A#{URI::regexp}\z/) &&  (video_url.match(BASE_URL_FMT) || video_url.match(REDIRECT_URL_FMT))
      errors.add(:video_url, :invalid)
    end
  end

  def normalized_url
    # if the video url has the id in the params just return it
    return video_url unless video_url&.match(REDIRECT_URL_FMT)

    # otherwise hit the url and get the redirect url which will have the id
    response = Net::HTTP.get_response(URI(video_url))

    # overwrite the video url
    response['location']
  end
end


