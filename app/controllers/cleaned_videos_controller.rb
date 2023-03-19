class CleanedVideosController < ApplicationController
  def index
    @video = VideoIdFromUrl.new
  end

  def new
    @video = VideoIdFromUrl.new
  end

  def create
    @video = VideoIdFromUrl.new(cleaned_video_params)
    id = @video.get_id
    if id.present?
      # TODO rescue from errors in here
      res = TikTokMetaApi.new.video_data(id)
      data = JSON.parse(res.body)
      video_data = data['aweme_list'][0]['video']
      @download_urls =  video_data['play_addr']['url_list']
      @cover = video_data['dynamic_cover']['url_list'][0]
    else
      render :new, status: 422
    end
  end

  private

  def cleaned_video_params
    params.require(:cleaned_video).permit(:video_url)
  end
end
