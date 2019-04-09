require 'pry'
require_relative "../config/environment.rb"

class Dog
    attr_accessor :id, :name, :breed

    def initialize(id: nil , name: , breed:)
        @id = id
        @name = name
        @breed = breed

    end

    def self.create_table
        DB[:conn].execute('CREATE TABLE dogs(ID INTEGER PRIMARY KEY, name TEXT, breed TEXT)')
    end

    def self.drop_table
        DB[:conn].execute('DROP TABLE dogs')
    end

    def self.new_from_db(hash)
        new_hash = {id:hash[0], name:hash[1], breed:hash[2]}
        Dog.new(new_hash)
    end

    def save
        if self.id
            DB[:conn].execute('UPDATE dogs SET name = ?, breed = ? WHERE id = ?',[name, breed, self.id])
        else
            DB[:conn].execute('INSERT INTO dogs(name, breed) VALUES (?,?)',[name, breed])
        end
        self
    end

    def self.create(hash)
        dog = self.new(hash)
        dog.save
        dog_hash = DB[:conn].execute('SELECT * FROM dogs WHERE name = ? AND breed = ?',[dog.name,dog.breed] ).flatten
        Dog.new(id:dog_hash[0], name:dog_hash[1], breed:dog_hash[2])
    end
    
    def self.find_by_name(name)
        dog =  DB[:conn].execute('SELECT * FROM dogs WHERE name = ?', name).flatten
       dog_hash = {id:dog[0], name:dog[1], breed:dog[2]}

       Dog.new(dog_hash)

        # result = DB[:conn].execute('SELECT * FROM dogs WHERE name = ?')
    end

    def self.find_by_id(id)
       dog =  DB[:conn].execute('SELECT * FROM dogs WHERE id = ?', id).flatten
       dog_hash = {id:dog[0], name:dog[1], breed:dog[2]}

       Dog.new(dog_hash)

    #    Dog.new(id:dog[0], name:dog[1], breed:dog[2])


    end
    
    def self.find_or_create_by(x)
        if x[:id] == nil
            
            # x.insert
            self.create(x)
            # Dog.find_by_id(self.id)
        else
            #binding.pry
            Dog.find_by_id(x[:id])
        end
        # binding.pry
    end

    def update
        DB[:conn].execute('UPDATE dogs SET name = ?, breed = ? WHERE id =?',self.name, self.breed, self.id)
    end


    # binding.pry
    # 0




end