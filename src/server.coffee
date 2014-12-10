express = require('express')
app = express()
bodyParser = require('body-parser')
http = require('http')
server = http.createServer(app)
request = require('request')

io = require('socket.io').listen(server)

leds = {}

app.use(bodyParser.urlencoded({
  extended: true
}))
app.use(bodyParser.json())

recordsUrl = 'http://localhost:3000/api/records'
server.listen(process.env.PORT || 4033)
console.log("Listening on port 4033")

getTransToken = (data)->
  transToken = data.transmitter_token # always being with a letter

io.sockets.on 'connection', (socket) ->
  console.log("WE have a connection yo")

  app.post '/scale', (req, res)->
    #console.log("post" + req.connection.remoteAddress)
    postData = {
      record:{
        y: req.body["A0"],
        transmitter_token: req.body.transmitter_token
        pin_number:"A0"}
    }
    options = {
      method: 'post',
      body:postData,
      json: true,
      url: recordsUrl
    }
    console.log "scale post"
    console.log req.body
    io.sockets.emit 'live', req.body
    token = getTransToken req.body
    console.log leds[token]
    res.send(leds[token])
    res.end
    #request options, (error, res, body) ->
    #if (!error && res.statusCode== 201)
    #console.log(body)
    
  socket.on 'get_leds', (data) ->
    console.log("GET LEDS")
    socket.emit 'leds', leds

  socket.on 'led', (data) ->
    console.log data
    transToken = getTransToken(data)
    transmitter =leds[transToken]
    if typeof transmitter == 'undefined'
      leds[transToken] = {}
      transmitter =leds[transToken]
      transmitter[data.pin_name] = data.value
    else 
      transmitter[data.pin_name] = data.value
    data = {}
    data[transToken] = transmitter
    io.sockets.emit 'leds', data




