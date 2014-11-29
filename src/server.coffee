express = require('express')
app = express()
bodyParser = require('body-parser')
http = require('http')
server = http.createServer(app)
request = require('request')

io = require('socket.io').listen(server)


red = 'RED OFF'
blue = 'BLUE OFF'
green = 'GREEN OFF'
app.use(bodyParser.urlencoded({
  extended: true
}))
app.use(bodyParser.json())

recordsUrl = 'http://localhost:3000/api/records'
server.listen(process.env.PORT || 4033)
console.log("Listening on port 4033")

sleep = (delay)->
  start = (new Date).getTime()
  i = 0
  while (new Date().getTime() < (start + delay))
    i = 1


io.sockets.on 'connection', (socket) ->
  console.log("WE have a connection yo")


  #while true
  console.log('emit')
  #sleep(3000)

  app.post '/scale', (req, res)->
    console.log("post" + req.connection.remoteAddress)
    console.log(req.body)
    weight = req.body["weight"]
    postData = {
      record:{
        value:weight,
        sensor_id: 1,
        transmitter_token:"5goPJ6bV-rSrkop7j4pmBg",
        pin_number:"a0"}
    }
    options = {
      method: 'post',
      body:postData,
      json: true,
      url: recordsUrl
    }
    io.sockets.emit 'live', req.body
    #res.send(red + blue + green + '\n')
    #res.end
    #request options, (error, res, body) ->
    #if (!error && res.statusCode== 201)
    #console.log(body)

  socket.on 'led', (data) ->
    console.log(data)
    if data.red
      red = 'RED ON'
    else 
      red = 'RED OFF'
    if data.blue
      blue = 'BLUE ON'
    else 
      blue = 'BLUE OFF'
    if data.green
      green = 'GREEN ON'
    else 
      green = 'GREEN OFF'


