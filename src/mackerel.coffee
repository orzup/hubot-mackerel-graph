# Description
#   mackerelのURLをいろいろ返してくれるbot
#
# Commands:
#   mackerel - サービス一覧を返す
#   mkr - サービス一覧を返す
#
# Author:
#   Asami Nakano <nakano.a@pepabo.com>

checkToken = (msg) ->
  unless process.env.HUBOT_MACKEREL_API_KEY?
    msg.send 'HUBOT_MACKEREL_API_KEYを設定してください'
    return false
  else
    return true

handleResponse = (msg, handler) ->
  (err, res, body) ->
    if err?
      msg.send "Failed to get mackerel api response: #{err}"

    switch res.statusCode
      when 404
        msg.send "Failed to get mackerel api response: Not Found", body
      when 401
        msg.send 'Failed to get mackerel api response: Not authorized', body
      when 500
        msg.send 'Failed to get mackerel api response: Internal server error', body
      when 200
        response = JSON.parse(body)
        handler response
      else
        msg.send "Failed to get mackerel api response: #{res.statusCode}", body

module.exports = (robot) ->
  robot.respond /(mackerel|mkr)$/i, (res) ->
    unless checkToken(res)
      return

    res.http("https://mackerel.io/api/v0/services")
      .headers("X-Api-Key": process.env.HUBOT_MACKEREL_API_KEY)
      .get() handleResponse res, (response) ->
        if response.length == 0
          res.send "Failed to get mackerel api response: resnponse is empty"
        else
          text = ""
          for service, i in response['services']
            text += "- " + service['name']
            if i < response['services'].length - 1
              text += "\n"
          res.send text
