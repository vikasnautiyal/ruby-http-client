# Loads environment variables from a .env file.
class Config
  def initialize
    File.open('./.env').readlines.each do |line|
      key, value = line.split '='
      ENV[key] = value.chomp
    end
    ENV
  end
end
