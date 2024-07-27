class HomeController < ApplicationController

  def index; end

  def qr_login
    @k1 = SecureRandom.hex(32)
    ln_url = LnUrlService.new("#{ENV['BASE_URL']}/auth?tag=login&k1=#{@k1}&action=login")
    @qr = RQRCode::QRCode.new(ln_url.encode).as_png(size: 1000)
  end
end
