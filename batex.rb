require "httpclient"

proxy = ENV['HTTP_PROXY']

c = HTTPClient.new(proxy)
c.ssl_config.set_client_cert_file("publicCert.pem", "privateKey.pem")
url = "https://production.bbc.co.uk/kandlcurriculum/cms_isite2/equation/preview"
regex = /<equation><tex>(.+?)<\/tex><\/equation>/  

latex = Array.new

File.open('content.xml').each_line do |line|
  line.scan(regex) { |match| latex << match }
end

puts "#{latex.size} instances of LaTeX detected, now submitting..."

latex.each do |line|
  c.post(url, 'latex' => line)
  print '.'
end

puts "\nComplete."