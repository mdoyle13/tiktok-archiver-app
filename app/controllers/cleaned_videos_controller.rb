class CleanedVideosController < ApplicationController
  def new
    @video = VideoIdFromUrl.new
  end

  def create
    @video = VideoIdFromUrl.new(cleaned_video_params)

    id = @video.get_id

    # TODO move all this login into the VideoIdFromUrl object and refactor
    if id.present?
      begin
        response = TikTokMetaApi.new.video_data(id)
        video_data = JSON.parse(response.body)['aweme_list'][0]['video']
        @download_urls =  video_data['play_addr']['url_list']
        @cover = video_data['dynamic_cover']['url_list'][0]
      rescue StandardError => e
        Rails.logger.debug e
        # TODO forward error to Sentry or other error tracking service
        @video.errors.add(:video_url, :parsing_error)
        render :new, status: 422
      end
    else
      render :new, status: 422
    end
  end

  private

  def cleaned_video_params
    params.require(:cleaned_video).permit(:video_url)
  end

  def parse_video_data(data)
    
  end
end
