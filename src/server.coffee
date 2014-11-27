http

express = require('express')
app = express()
bodyParser = require('body-parser')
http = require('http')
server = http.createServer(app)
io = require('socket.io').listen(server)

app.use(bodyParser())

server.listen(process.env.PORT || 3507)
console.log("Listening on port 3507")


io.sockets.on 'connection', (socket) ->
  console.log("WE have a connection yo")

  setTimeout(->
    socket.emit 'test', { record: {
      id:153
      time_stamp:1418111217000
      sensor_id: 1
      value: 500}
    }
  , 1000)

  setTimeout(->
    socket.emit 'test', { record: {
      id:154
      time_stamp: 1419111217000
      sensor_id: 1
      value: 1000}
    }
  , 3000)

  setTimeout(->
    socket.emit 'test', { record: {
      id:155
      time_stamp: 1420111217000
      sensor_id: 1
      value: 1500}
    }
  , 6000)



  socket.on 'comeback', (data) ->
    console.log(data)


