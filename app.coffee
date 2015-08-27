app = require('express')()
server = require('http').Server(app)
io = require('socket.io')(server)
cp = require('child_process')

server.listen 8080

app.get '/', (req, res)->
	res.sendfile __dirname + '/web/'+'/index.html'

app.get /(?:js|css|showdown)/, (req,res)->
	res.sendfile __dirname + '/web/'+ req.path

app.get /data/, (req,res)->
	res.sendfile __dirname +  req.path

runscript = (cmd,socket)->
	console.log(cmd)
	run = cp.exec cmd,{}

	socket.emit "log","CMD start #{cmd}"

	run.stdout.on 'data',  (data)-> 
		socket.emit "log",data

	run.stderr.on 'data', (data)->
		socket.emit 'err',data

	run.on 'exit',()->
		socket.emit "log","CMD #{cmd} finish"

fs = require 'fs'

sendfile = (file)->
	str = fs.readFileSync(file, 'utf-8');
	return str
	
io.on 'connection', (socket) ->

	socket.emit 'log','successfully connect' 	

	socket.on 'runscript',(data)->
		runscript data,socket

	socket.on 'needfile',(data)->
		resp = 
			name : data['filename']
			type : data['type']
			container:data["container"]
			content :sendfile data['filename']
		socket.emit "file",resp
