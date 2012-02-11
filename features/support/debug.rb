module CommandHelpers
  def pause_page
    $stdout.puts
    $stdout.puts "Press enter to continue"
    $stdin.gets
  end
end

World(CommandHelpers)
