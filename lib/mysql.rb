class MySQL

  def initialize(username, password)
    @username = username
    @password = password
  end

  def exec(sql)
    command = "sudo #{mysql} --user=#{username} --password=#{password} --verbose -e \"#{sql}\""
    system(command)
  end

  def result(sql)
    command = "sudo #{mysql} --user=#{username} --password=#{password} --verbose -e \"#{sql}\""
    `#{command}`
  end

  def username
    @username
  end

  def password
    @password
  end

  def mysqldump
    'mysqldump'
  end

  def mysql
    'mysql'
  end

  def export(database_name, file_name = nil)
    file_name = "#{database_name}.sql" if file_name.nil?

    dest = File.join(Dir.pwd, file_name)

    command = "sudo #{mysqldump} --opt --user=#{username} --password=#{password} #{database_name} > #{dest}"

    system(command)

    puts "dumped database to #{dest}"
  end

  def import(file, database)
    src = File.join(Dir.pwd, file)

    exec("CREATE DATABASE IF NOT EXISTS #{database}")
    command = "sudo mysql --user=#{username} --password=#{password} --verbose #{database} < #{src}"
    system(command)
  end

  def tables
    lines = result("SHOW DATABASES")
    lines.split("\n")[5..-1]
  end

end