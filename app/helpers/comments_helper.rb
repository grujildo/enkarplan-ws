module CommentsHelper
  def comment_url(comment)
    "/#{t 'resources.pois'}/#{comment.poi.slug}#comment-#{comment.id}" if comment.poi
  end
end
