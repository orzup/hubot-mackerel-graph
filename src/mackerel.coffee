# Description
#   mackerelのURLをいろいろ返してくれるbot
#
# Commands:
#   hubot mackerel - ダッシュボードのURLを返す
#
# Author:
#   Asami Nakano <nakano.a@pepabo.com>

checkToken = (msg) ->
  unless process.env.HUBOT_MACKEREL_API_KEY?
    msg.send 'HUBOT_MACKEREL_API_KEYを設定してください'
    return false
  else
    return true

module.exports = (robot) ->
  robot.respond /mackerel$/i, (res) ->
    res.send "https://mackerel.io/orgs/pepabo/dashboard"

  robot.respond /mackerel (\w+)$/i, (res) ->
    unless checkToken(res)
      return
    res.send res.match[1]
