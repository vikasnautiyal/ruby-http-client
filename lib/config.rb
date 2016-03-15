class Config
  def initialize()
    File.open("./.env").readlines.each do |line|
      key, value = line.split "=" 
      ENV[key] = value.chomp
    end
    return ENV
  end
end