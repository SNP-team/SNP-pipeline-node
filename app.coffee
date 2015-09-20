app = require('express')()
server = require('http').Server(app)
io = require('socket.io')(server)
cp = require('child_process')
path = require('path')
phantomjs = require('phantomjs')
pdf = require('node-html-pdf')
fs = require('fs')


config =
	'directory': '/tmp'
	'height': '10.5in'
	'width': '8in'
	'format': 'Letter'
	'orientation': 'portrait'
	'border': '0'
	'border':
		'top': '2in'
		'right': '1in'
		'bottom': '2in'
		'left': '1.5in'
	'header':
		'height': '45mm'
		'contents': '<div style="text-align: center;">Author: Marc Bachmann</div>'
	'footer':
		'height': '28mm'
		'contents': '<span style="color: #444;">{{page}}</span>/<span>{{pages}}</span>'
	'type': 'pdf'
	'quality': '75'
	'phantomPath': './node_modules/phantomjs/bin/phantomjs'
	'phantomArgs': []
	'script': '/url'
	'timeout': 30000
	'httpHeaders': 'Authorization': 'Bearer ACEFAD8C-4B4D-4042-AB30-6C735F5BAC8B'


server.listen 8080

app.get '/', (req, res)->
	res.sendfile __dirname + '/web/'+'/index.html'

app.get /(?:js|css|showdown)/, (req,res)->
	res.sendfile __dirname + '/web/'+ req.path

app.get /data/, (req,res)->
	res.sendfile(path.resolve(__dirname + '/../' + req.path))


runscript = (cmd,socket)->
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
	filepath = __dirname + '/../'+ file
	str = fs.readFileSync(filepath, 'utf-8');

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

	socket.on 'serverlog',(data)->
		console.log data

	socket.on 'convertpdf',(html)->
		console.log html
		console.log 'convertpdf called'
		filename = __dirname + '/report.pdf'
		pdf.create(html, config).toFile(filename, (err, res)->
			console.log	"filename: " + filename
			if err
				return console.log(err)
			console.log(res)
			socket.emit	'convertpdffinished', filename
		)
