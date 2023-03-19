class TikTokMetaApi
  include HTTParty
  base_uri 'api16-normal-c-useast1a.tiktokv.com/aweme/v1/feed'

  def intiailize; end

  def video_data(id)
    self.class.get('/', { query: { aweme_id: id } })
  end

  def normalized_video_url(url)
    self.class.get(url)
  end
end