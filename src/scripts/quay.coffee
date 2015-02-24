# Description:
# 	Quay.io support.
#
# Dependencies:
#
# Configuration:
# 	HUBOT_QUAY_SECRET
# 	HUBOT_QUAY_DEFAULT_ROOM
#
# Commands:
# 	hubot quay status
#
# Author:
# 	JonGretar
#
querystring = require('querystring');
quay_room = process.env.HUBOT_QUAY_DEFAULT_ROOM
quay_secret = process.env.HUBOT_QUAY_SECRET

building = {};

module.exports = (robot) ->

	robot.router.post "/hubot/quay", (req, res) ->
		query = querystring.parse(req._parsedUrl.query)
		if query.secret != quay_secret
			return res.end("Invalid Secret")

		envelope = {}
		envelope.user = {}
		envelope.user.room = envelope.room = quay_room if quay_room
		envelope.user.room = envelope.room = query.room if query.room
		envelope.user.type = query.type or 'groupchat'

		body = req.body
		console.log(req.body)

		message = "Got a quay webhook that I didn't understand"
		if body.updated_tags
			message = "Successfully pushed to [body.repository](http://#{body.docker_url}) the tags: #{Object.keys(body.updated_tags).join(', ')}"
		else if body.is_manual != undefined
			message = "Dockerfile build queued for [body.repository](http://#{body.docker_url})#(#{body.docker_tags.join(', ')})"
		else if body.error_message
			message = "Build failed [body.repository](http://#{body.docker_url}): #{body.error_message}"
			delete building[body.build_id]
		else if body.build_id && !building[body.build_id]
			message = "Dockerfile build started for [body.repository](http://#{body.docker_url})#(#{body.docker_tags.join(', ')})"
			building[body.build_id] = true
		else if body.build_id && building[body.build_id]
			message = "Dockerfile build completed for [body.repository](http://#{body.docker_url})#(#{body.docker_tags.join(', ')})"
			delete building[body.build_id]

		robot.send envelope, message

		res.end ""

	robot.respond /quay status.*/i, (msg) ->
		msg
			.http('http://status.quay.io/')
			.header("Accept", "application/json")
			.get() (error, response, body) ->
				results = JSON.parse body
				msg.send "Quay.io Status: #{results.status.description}"
