module ColorHelpers
  def hex_str_to_rgb(hex)
    hex.scan(/../).map { |color| color.to_i(16) }
  end
end

World(ColorHelpers)
