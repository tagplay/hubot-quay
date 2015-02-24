# Hubot Quay.io

## Installation

	npm install hubot-quay

## Configuration

 * **HUBOT_QUAY_SECRET** - Secret key for webhooks
 * **HUBOT_QUAY_DEFAULT_ROOM** - Default room for messages

## Webhooks

### /hubot/quay

Receive and print build status information.

#### Parameters:

 * **secret**: *[required]* The secret key. Must be the same as `HUBOT_QUAY_SECRET`
 * **room**: *[optional]* Override the `HUBOT_QUAY_DEFAULT_ROOM` configuration

**Example:**

	https://myhubot.example.com/hubot/quay?secret=mysecret


## Commands

### Status

Retrieve the status of Quay.io service

	@hubot status
