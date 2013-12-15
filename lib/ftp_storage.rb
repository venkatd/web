class FtpStorage

  def initialize(host, username, password)
    connect(host, username, password)
  end

  def connect(host, username, password)
    @host, @username, @password = host, username, password

    @ftp = Net::FTP.new(@host)
    @ftp.passive = true
    @ftp.debug_mode = true
    @ftp.login(@username, @password)
  end

  def commit_hash
    @ftp.gettextfile('commit_hash') unless file_exists?('commit_hash')
  end

  def download(remote_filepath, local_filepath)
    @ftp.getbinaryfile(remote_filepath, local_filepath)
  end

  def upload(remote_filepath, local_filepath)
    @ftp.putbinaryfile(remote_filepath, local_filepath)
  end

  def delete(filepath)_
    @ftp.delete(filepath)
  end

  def create_dir(dirname)
    @ftp.mkdir(dirname)
  end

  def create_path(path)
    each_directory_in_path(path) do |cur_path|
      create_dir(cur_path) unless dir_exists?(cur_path)
    end
  end

  def each_directory_in_path(path)
    parts = path.split('/')
    parts.each_index do |index|
      cur_path = parts[0..index].join('/')
      yield cur_path
    end
  end

  def destroy_dir(dirname)
    @ftp.rmdir(dirname)
  end

  def file_exists?(filepath)
    begin
      @ftp.size(filepath)
    rescue Net::FTPReplyError => e
      reply = e.message
      err_code = reply[0,3].to_i
      unless err_code == 500 || err_code == 502
        # other problem, raise
        raise
      end
      # fallback solution
    end
      true
  end

  def dir_exists?(directory)
    prev_dir = @ftp.getdir

    begin
      @ftp.chdir(directory)
      success = true
    rescue Net::FTPPermError => e
      success = false
    end

    @ftp.chdir(prev_dir)

    return success
  end


  def close
    @ftp.close
  end

end
