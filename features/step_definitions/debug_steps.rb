require 'ruby-debug'

When /^I enter the debugger$/ do
  debugger
end

When /^pause the page$/ do
  pause_page
end

module CommandHelpers
  def pause_page
    puts
    puts "Press enter to continue"
    $stdin.gets
  end
end

World(CommandHelpers)
