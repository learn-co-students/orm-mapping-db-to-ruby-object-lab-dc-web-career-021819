class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    stu = self.new
    stu.id = row[0]
    stu.name = row[1]
    stu.grade = row[2]
    stu
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
        SELECT * FROM students;
        SQL

    DB[:conn].execute(sql).collect{|x| self.new_from_db(x)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
        SELECT * FROM students WHERE name = ? LIMIT 1
        SQL

    DB[:conn].execute(sql, name).collect{|x| self.new_from_db(x)}.first
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
        SELECT * FROM students WHERE grade = 9
        SQL
    DB[:conn].execute(sql).collect{|s| self.new_from_db(s)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
        SELECT * FROM students WHERE grade < 12
        SQL
    DB[:conn].execute(sql).collect{|s| self.new_from_db(s)}
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
        SELECT * FROM students WHERE grade = 10 LIMIT ?
        SQL
    DB[:conn].execute(sql, num).collect{|s| self.new_from_db(s)}
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
        SELECT * FROM students WHERE grade = 10 LIMIT 1
        SQL
    DB[:conn].execute(sql).collect{|s| self.new_from_db(s)}.first
  end

  def self.all_students_in_grade_X(num)
    sql = <<-SQL
        SELECT * FROM students WHERE grade = ?
        SQL
    DB[:conn].execute(sql, num).collect{|s| self.new_from_db(s)}
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
end
