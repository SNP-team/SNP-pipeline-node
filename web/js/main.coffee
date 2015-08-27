socket = io('http://localhost:8080')

socket.on 'log', (data)->
	$("#log").append "<li class='list-group-item'>#{data}</li>"

socket.on 'err', (data)->
	$("#log").append "<li class='list-group-item list-group-item-danger' >#{data}</li>"

run00= ()->
	homedir = $("#homedir").val()
	groupname = $("#groupname").val()
	file1 = $("#prepro1").val()
	jar = $("#jar").val()
	str = "java -Xmx10g -jar #{jar} 0 #{homedir}/data/#{groupname}/#{file1} #{homedir}/data/#{groupname}/temp/learn_0.csv"
	socket.emit 'runscript',str

run01= ()->
	homedir = $("#homedir").val()
	groupname = $("#groupname").val()
	file2 = $("#prepro2").val()
	jar = $("#jar").val()
	str = "java -Xmx10g -jar #{jar} 0 #{homedir}/data/#{groupname}/#{file2} #{homedir}/data/#{groupname}/temp/valid_0.csv"
	socket.emit 'runscript',str

run1=()->
	#java -Xmx50g -jar "C:\Users\Aaron\Desktop\analysis\dist\analysis.jar" 1 true 
	#"C:\Users\Aaron\Desktop\learn_0.csv" "C:\Users\Aaron\Desktop\learn_0_pheno.csv" 
	#"C:\Users\Aaron\Desktop\valid_0.csv" "C:\Users\Aaron\Desktop\valid_0_pheno.csv"
	file1 = 'learn_0.csv'
	file2 = 'learn_0_pheno.csv'
	file3 = 'valid_0.csv'
	file4 = 'valid_0_pheno.csv'
	jar = $("#jar").val()
	homedir = $("#homedir").val()
	groupname = $("#groupname").val()

	str = "java -Xmx10g -jar #{jar} 1 true #{homedir}/data/#{groupname}/temp/#{file1} #{homedir}/data/#{groupname}/temp/#{file2} #{homedir}/data/#{groupname}/temp/#{file3} #{homedir}/data/#{groupname}/temp/#{file4}"
	socket.emit 'runscript',str


run2=()->
	#java -Xmx50g -jar "C:\Users\Aaron\Desktop\analysis\dist\analysis.jar" 1 true 
	#"C:\Users\Aaron\Desktop\learn_0.csv" "C:\Users\Aaron\Desktop\learn_0_pheno.csv" 
	#"C:\Users\Aaron\Desktop\valid_0.csv" "C:\Users\Aaron\Desktop\valid_0_pheno.csv"
	file1 = 'training_01.arff'
	file2 = 'validation_01.arff'
	jar = $("#jar").val()
	homedir = $("#homedir").val()
	groupname = $("#groupname").val()

	str = "java -Xmx13g -jar #{jar} 2 true 50000 4000 #{homedir}/data/#{groupname}/temp/#{file1} #{homedir}/data/#{groupname}/temp/#{file2}"
	socket.emit 'runscript',str

run3=()->
	#java -Xmx50g -jar "C:\Users\Aaron\Desktop\analysis\dist\analysis.jar" 1 true 
	#"C:\Users\Aaron\Desktop\learn_0.csv" "C:\Users\Aaron\Desktop\learn_0_pheno.csv" 
	#"C:\Users\Aaron\Desktop\valid_0.csv" "C:\Users\Aaron\Desktop\valid_0_pheno.csv"
	file1 = 'training_01_PostBayesAttSel.arff'
	file2 = 'validation_01_PostBayesAttSel.arff"'
	jar = $("#jar").val()
	homedir = $("#homedir").val()
	groupname = $("#groupname").val()
	str = "java -Xmx10g -jar #{jar} #{homedir}/data/#{groupname}/temp/#{file1} #{homedir}/data/#{groupname}/temp/#{file2}"
	socket.emit 'runscript',str

run3_1=()->
	#java -Xmx50g -jar "C:\Users\Aaron\Desktop\analysis\dist\analysis.jar" 1 true 
	#"C:\Users\Aaron\Desktop\learn_0.csv" "C:\Users\Aaron\Desktop\learn_0_pheno.csv" 
	#"C:\Users\Aaron\Desktop\valid_0.csv" "C:\Users\Aaron\Desktop\valid_0_pheno.csv"
	file1 = 'a.arff'
	file2 = 'b.arff"'
	jar = $("#jar").val()
	homedir = $("#homedir").val()
	groupname = $("#groupname").val()
	str = "java -Xmx10g -jar #{jar} #{homedir}/data/#{groupname}/temp/#{file1} #{homedir}/data/#{groupname}/temp/#{file2}"
	socket.emit 'runscript',str

mkchart=(container,array)->
	
	str = "<table class='table table-striped table-bordered'>"

	for a in array
		str += "<tr>"
		for b in a
			str += "<td>"+ b + "</td>"
		str += "</tr>"
	str+="</table>"

	container.html(str)


renderfiletabdou=(file,container)->
	resp=
		filename : file 
		type : 'tabdou'
		container:container
	socket.emit 'needfile',resp

renderfiletab=(file,container)->
	resp=
		filename : file 
		type : 'tab'
		container:container
	socket.emit 'needfile',resp


split_tab_dou =(str)->
	str = str.replace /,/g,'\t'
	return split_tab str
split_tab_dou =(str)->
	str = str.replace /,/g,'\t'
	return split_tab str

split_tab=(str)->
	lines = str.split '\n'
	res = []
	for a of lines
		res[a] = lines[a].split '\t'
	return res

socket.on 'file',(data)->
	str = data['content']
	container = data['container']
	console.log data['type']
	if data['type']=='tabdou'
		mkchart $("#"+container),(split_tab_dou str)
	else if data['type']=='tab'
		mkchart $("#"+container),(split_tab str)
		console.log 'here'

exports = this
exports.run00 = run00

exports.run01 = run01

exports.run1 = run1
exports.run2 = run2
exports.run3 = run3
exports.mkchart = mkchart
exports.renderfiletabdou = renderfiletabdou
exports.renderfiletab = renderfiletab
