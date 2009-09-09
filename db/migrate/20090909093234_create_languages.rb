class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
      t.string :name
      t.string :code
    end
    Rake::Task["load_languages"].invoke
  end

  def self.down
    drop_table :languages
  end
end
