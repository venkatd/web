class MySQL

  def initialize(options)
    @options = options
  end

  def exec(sql)
    command = "sudo #{mysql} --verbose -e \"#{sql}\""
    system(command)
  end

  def result(sql)
    command = "sudo #{mysql} --verbose -e \"#{sql}\""
    `#{command}`
  end

  def options(*include)
    opts = @options.to_hash

    opts[:user] = opts[:username]
    opts.delete(:username)
    opts = opts.select { |k, v| include.include?(k) && v != nil && v != "" }
    opts.map { |option, value| "--#{option}=#{value}"}.join(" ")
  end

  def username
    @options[:username]
  end

  def password
    @options[:password]
  end

  def mysqldump
    "mysqldump #{options :user, :password, :host, :port, :protocol}"
  end

  def mysql
    "mysql #{options :user, :password, :host, :port, :protocol}"
  end

  def export(database_name, file_name = nil)
    file_name = "#{database_name}.sql" if file_name.nil?

    dest = File.join(Dir.pwd, file_name)

    command = "sudo #{mysqldump} --verbose --opt #{database_name} > #{dest}"

    puts command

    system(command)

    puts "dumped database to #{dest}"
  end

  def import(file, database)
    src = File.join(Dir.pwd, file)

    exec("CREATE DATABASE IF NOT EXISTS #{database}")
    command = "sudo #{mysql} --verbose #{database} < #{src}"
    system(command)
  end

  def console
    puts mysql
    system(mysql)
  end

  def tables
    lines = result("SHOW DATABASES")
    lines.split("\n")[5..-1]
  end

end
