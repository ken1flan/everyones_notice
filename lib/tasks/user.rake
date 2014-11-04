namespace :user do
  desc "ユーザを招待する"
  task invite: :environment do
    mail_address = ENV["MAIL_ADDRESS"]
    club_id = ENV["CLUB_ID"]
    admin = ENV["ADMIN"].present?
    invitation = Invitation.create( mail_address: mail_address, club_id: club_id, admin: admin )
    puts "mail_address: #{ invitation.mail_address }"
    puts "token: #{ invitation.token }"
  end
end
