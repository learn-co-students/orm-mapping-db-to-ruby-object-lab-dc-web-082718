require 'pry'
class Student
  attr_accessor :id, :name, :grade



  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = Student.new
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student.id = row[0]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL
    found_student_row = DB[:conn].execute(sql, name)[0]
    found_student_obj = Student.new
    found_student_obj.name = found_student_row[1]
    found_student_obj.grade = found_student_row[2]
    found_student_obj.id = found_student_row[0]
    found_student_obj
    #binding.pry
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
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 9
    SQL
    student_rows = DB[:conn].execute(sql)
    student_rows.map do |student_row|
      Student.new_from_db(student_row)
    end

  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12
    SQL
    student_rows = DB[:conn].execute(sql)
    student_rows.map do |student_row|
      Student.new_from_db(student_row)
    end
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    student_rows = DB[:conn].execute(sql)
    student_rows.map do |student_row|
      Student.new_from_db(student_row)
    end
  end

  def self.first_X_students_in_grade_10(limit)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 ORDER BY students.id LIMIT ?
    SQL
    student_rows = DB[:conn].execute(sql, limit)
    student_rows.map do |student_row|
      Student.new_from_db(student_row)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 ORDER BY students.id LIMIT 1
    SQL
    student_row = DB[:conn].execute(sql)[0]
    # student_rows.map do |student_row|
       Student.new_from_db(student_row)
    # end
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    student_rows = DB[:conn].execute(sql, grade)
    student_rows.map do |student_row|
      Student.new_from_db(student_row)
    end
  end

end
