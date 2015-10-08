# Description
#   mackerelのURLをいろいろ返してくれるbot
#
# Commands:
#   hubot mackerel - ダッシュボードのURLを返す
#
# Author:
#   Asami Nakano <nakano.a@pepabo.com>

module.exports = (robot) ->
  robot.respond /mackerel$/i, (res) ->
    res.send "https://mackerel.io/orgs/pepabo/dashboard"

  robot.respond /mackerel (\w+)$/i, (res) ->
    res.send res.match[1]
