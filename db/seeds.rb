unless Plan.where(name: "Basic").exists?
  Plan.create(:name => "Basic", :price => 3.00)
end

["Suggestion", "Problem"].each do |category_name|
  unless DiscussionCategory.where(name: category_name).exists?
    DiscussionCategory.create(name: category_name)
  end
end
