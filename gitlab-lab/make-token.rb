user = User.find_by_username('root')
token = user.personal_access_tokens.create!(scopes: %i[api read_repository write_repository], name: 'mere-mortals-lab', expires_at: 7.days.from_now)
puts 'TOKEN-VALUE: ' + token.token
puts 'token created for ' + user.username + ', id ' + token.id.to_s
