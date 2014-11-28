express = require('express')
app = express()
bodyParser = require('body-parser')
http = require('http')
server = http.createServer(app)
request = require('request')

io = require('socket.io').listen(server)


app.use(bodyParser.urlencoded({
  extended: true
}))
app.use(bodyParser.json())

recordsUrl = 'http://localhost:3000/api/records'
server.listen(process.env.PORT || 4033)
console.log("Listening on port 4033")


io.sockets.on 'connection', (socket) ->
  console.log("WE have a connection yo")

  app.post '/scale', (req, res)->
    console.log("post" + req.connection.remoteAddress)
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
    io.sockets.emit 'test', postData
    #request options, (error, res, body) ->
    #if (!error && res.statusCode== 201)
    #console.log(body)

  socket.on 'comeback', (data) ->
    console.log(data)


