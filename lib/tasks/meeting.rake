desc "Send meetings today summary to users"
task :send_summaries => :environment do
  for user in User.no_admins
    user.send_summary
    puts "[#{Time.now.to_s(:short)}] Sumary sent to #{user.login}"
    sleep 1
  end
end
