# Description
#   mackerelのURLをいろいろ返してくれるbot
#
# Commands:
#   mackerel - サービス一覧を返す
#   mkr - サービス一覧を返す
#   mkr service - サービスのロール一覧を返す
#   mkr service role - ロールのloadavg5へのURLを返す
#   mkr service role graph - ロールのグラフ画像へのURLを返す
#
# Author:
#   Asami Nakano <nakano.a@pepabo.com>
HOST = "https://mackerel.io"

checkToken = (msg) ->
  if process.env.HUBOT_MACKEREL_API_KEY?
    return true

  msg.send 'HUBOT_MACKEREL_API_KEYを設定してください'
  return false

checkOrg = (msg) ->
  if process.env.HUBOT_MACKEREL_ORG?
    return true

  msg.send 'HUBOT_MACKEREL_ORGを設定してください'
  return false

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

textFormat = (data, select) ->
  if data.length == 0
    return "Failed to get mackerel api response: resnponse is empty"

  text = ""
  for temp, i in data[select]
    text += "- " + temp['name']
    if i < data[select].length - 1
      text += "\n"
  return text

graphURLFormat = (service, role, graph) ->
  if graph == undefined
    graph = "loadavg5"
  return "#{HOST}/embed/orgs/#{process.env.HUBOT_MACKEREL_ORG}/services/#{service}/#{role}.png?graph=#{graph}"

module.exports = (robot) ->
  robot.respond /(?:mackerel|mkr)$/i, (res) ->
    unless checkToken(res)
      return

    res.http("#{HOST}/api/v0/services")
      .headers("X-Api-Key": process.env.HUBOT_MACKEREL_API_KEY)
      .get() handleResponse res, (response) ->
        res.send textFormat(response, 'services')

  robot.respond /(?:mackerel|mkr) (\S+)$/i, (res) ->
    unless checkToken(res)
      return

    res.http("#{HOST}/api/v0/services/#{res.match[1]}/roles")
      .headers("X-Api-Key": process.env.HUBOT_MACKEREL_API_KEY)
      .get() handleResponse res, (response) ->
        res.send textFormat(response, 'roles')

  robot.respond /(?:mackerel|mkr) (\S+) (\S+)(?: (\S+))?$/i, (res) ->
    unless checkOrg(res)
      return

    res.send graphURLFormat(res.match[1], res.match[2], res.match[3])
