class Support::DiscussionCategoriesController < Support::BaseController
  def show
    @category = DiscussionCategory.find(params[:id])
    @discussions = @category.discussions.public.page(params[:page]).per(10)
    @discussion = @category.discussions.build
  end
end
