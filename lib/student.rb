require 'pry'

class Student
  attr_accessor :id, :name, :grade

  # def initialize (id=nil, name, grade)
  #   @id, @name, @grade = id, name, grade
  # end

@@all = []

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new()
    student.id, student.name, student.grade = row[0], row[1], row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students"
    self.instantiate(sql)
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    row = DB[:conn].execute(sql, name).flatten
    # student = self.new
    # student.id, student.name, student.grade = row[0], row[1], row[2]
    # student
    self.new_from_db(row)
  end

  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"
    row = DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
    # binding.pry
    self.instantiate(sql)
  end

  def self.first_X_students_in_grade_10 (x)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    # binding.pry
    self.instantiate(sql, x)
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1"
    # binding.pry
    self.instantiate(sql).first
  end

  def self.all_students_in_grade_X (x)
    sql = "SELECT * FROM students WHERE grade = ?"
    # binding.pry
    self.instantiate(sql, x)
  end

          # ////////////////// SUPPORT METHODS ////////////////// #

          def self.instantiate (sql, *parameters)
            students = DB[:conn].execute(sql, parameters).map {|row|
              self.new_from_db(row)
            }
          end

          # ////////////////// ///////////////// ///////////////// #

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end


end
