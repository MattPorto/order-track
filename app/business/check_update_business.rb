class CheckUpdateBusiness
  def connect
    agent = Mechanize.new
    page = agent.get("http://radar.tntbrasil.com.br/radar/public/localizacaoSimplificadaDetail/ODI1NzY4OTU=")
    json_unparsed = page.body[(page.body.index("var json =") + 12)..(page.body.index("    }  }}';\r\n\t") + 8)]
    response = JSON.parse(json_unparsed)
    msg_prefx = response["viewOptions"]["gridOcorrencias"]["aaData"]
    message = msg_prefx.last["occurrence"] + ' ' + (msg_prefx.last["branch"])

    ol = OrderLocation.find_or_create_by(
      message: message.force_encoding("ISO-8859-1").encode("UTF-8"),
      checkout: response["viewOptions"]["gridOcorrencias"]["aaData"].last["timeDate"].to_datetime
    )

    ol.update_attributes(created_at: Time.now.localtime.to_datetime) if ol.created_at.nil?

    if ol.created_at >= Time.now - 1.hour && ol.created_at < Time.now
      if Time.now.hour < 23 && Time.now.hour > 9
        send_sms(ol)
      end
    end
  end

  private

  def send_sms(ol)
    account_sid = Rails.application.secrets['ACCOUNT_SID']
    auth_token = Rails.application.secrets['AUTH_TOKEN']

    client = Twilio::REST::Client.new account_sid, auth_token

    client.api.account.messages.create(
      from: "+#{Rails.application.secrets['TW_NMB']}",
      to: "+#{Rails.application.secrets['MNMB']}",
      body: "Localizacao da Carga:\n Horario: #{ol.checkout.to_s.humanize}\n #{ol.message}"
    )
  end
end
