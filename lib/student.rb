require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
      SQL
      DB[:conn].execute(sql).map do|row|
      self.new_from_db(row)

    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    SELECT * FROM students WHERE name = ? LIMIT 1
    SQL

    DB[:conn].execute(sql,name).collect do |row|
      self.new_from_db(row)
    end.first

  end

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

  def self.all_students_in_grade_9
    #   The .all_students_in_grade_9 Method
    # This is a class method that does not need an argument. This method should return an array of all the students in grade 9.
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 9
    SQL

    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    # The .students_below_12th_grade Method
    # This is a class method that does not need an argument. This method should return an array of all the students below 12th grade.
    #
    sql = <<-SQL
    SELECT * FROM students WHERE grade < 12
    SQL

    DB[:conn].execute(sql).collect do |row|
    self.new_from_db(row)
    end
  end

# The .first_X_students_in_grade_10 Method
# This is a class method that takes in an argument of the number of students from grade 10 to select. This method should return an array of exactly X number of students.
  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
    SELECT * FROM students where grade = 10 LIMIT ?
    SQL
    DB[:conn].execute(sql,num).collect do |row|
      self.new_from_db(row)
    end
  end
# The .first_student_in_grade_10 Method
# This is a class method that does not need an argument. This should return the first student that is in grade 10.
#
 def self.first_student_in_grade_10
   sql = <<-SQL
        SELECT * FROM students WHERE grade = 10 LIMIT 1
        SQL
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end.first
 end
# The .all_students_in_grade_X Method
# This is a class method that takes in an argument of grade for which to retrieve the roster. This method should return an array of all students for grade X.
    def self.all_students_in_grade_X(grade)
      sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
      SQL
      DB[:conn].execute(sql,grade).collect do |row|
      self.new_from_db(row)
      end
    end
end
