express = require('express')
app = express()
bodyParser = require('body-parser')
http = require('http')
server = http.createServer(app)
request = require('request')

io = require('socket.io').listen(server)

leds = {}
sensors = {}

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

  app.post '/value', (req, res)->
    transToken = req.body.transmitter_token
    pin = req.body.pin
    y = sensors[transToken][pin]
    postData = {
      record:{
        y: y
        transmitter_token: transToken
        pin_number:pin}
    }
    options = {
      method: 'post',
      body:postData,
      json: true,
      url: recordsUrl
    }
    request options, (error, res, body) ->
      if (!error && res.statusCode== 201)
        console.log(body)
    

  app.post '/scale', (req, res)->
    #console.log("post" + req.connection.remoteAddress)
    sensors[req.body.transmitter_token] = req.body
    console.log req.body
    io.sockets.emit 'live', req.body
    token = getTransToken req.body
    res.send(leds[token])
    res.end
    
  socket.on 'get_leds', (data) ->
    console.log("GET LEDS")
    socket.emit 'leds', leds

  socket.on 'led', (data) ->
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




