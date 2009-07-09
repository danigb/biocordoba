class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table "roles", :force => true do |t|
      t.column "title", :string
    end
    create_table "roles_users", :id => false, :force => true do |t|
      t.column "role_id", :integer
      t.column "user_id", :integer
    end

    %w(admin exhibitor buyer).each do |title|
      Role.create :title => title
    end

    user = User.create(:login => 'admin', :password => 'eventos86', 
       :password_confirmation => 'eventos86', :email => 'dacosta@superagencia86.com')
    user.roles << Role.find_by_title('admin')

  end

  def self.down
    drop_table :roles
  end
end
