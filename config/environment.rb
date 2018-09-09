require 'sqlite3'
require_relative '../lib/student'

#connection to database
DB = {:conn => SQLite3::Database.new("db/students.db")}
