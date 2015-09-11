class CreateProfilesTable < ActiveRecord::Migration
  def change
  	create_table :profiles do |t|
		t.string :fname
		t.string :lname
		t.string :location
		t.string :occupation
		t.integer :age
		t.integer :userid  		
  	end
  end
end
