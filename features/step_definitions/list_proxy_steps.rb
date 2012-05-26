Given /^the following list proxy exists for "([^"]+)":$/ do |email, table|
  user = User.find_by_email!(email)
  data = table.hashes.first
  list_attributes = if list_data = data.delete("list")
                      Hash[*list_data.split(": ")]
                    else
                      {}
                    end
  list = create(:list, list_attributes.merge(user: user))
  proxy = user.list_proxies.where(list_id: list.id).first
  proxy.update_attributes(data)
end
