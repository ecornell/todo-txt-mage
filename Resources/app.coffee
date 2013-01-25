# /**
# * Copyright (c) 2013 Elijah Cornell
# *
# * Licensed under the Apache License, Version 2.0 (the "License")
# * you may not use this file except in compliance with the License.
# * You may obtain a copy of the License at
# *
# *	http://www.apache.org/licenses/LICENSE-2.0
# *
# * Unless required by applicable law or agreed to in writing, software
# * distributed under the License is distributed on an "AS IS" BASIS,
# * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# * See the License for the specific language governing permissions and
# * limitations under the License.
# **/


@TodoCtrl = ($scope) ->
	$scope.todoText = 'testing'


#


todo_txt_dir = '/Users/eli/Documents/todo'


tasks = null
contexts = null
projects = null
tags = null


init = ->
	menu = Ti.UI.createMenu()
	fileItem = Ti.UI.createMenuItem('File')
	exitItem = fileItem.addItem('Exit', ->
		if (confirm('Are you sure you want to quit?'))
			Ti.App.exit()
	)

	menu.appendItem(fileItem)
	Ti.UI.setMenu(menu)

	#
	# $("#add").focus( ->
	#     $(this).data("hasfocus", true);
	# );

	# $("#add").blur( ->
	#     $(this).data("hasfocus", false);
	# );

	# $("#add").keyup( (ev) ->
	#     if (ev.which == 13 && $(this).data("hasfocus"))
	#         addTask( $(this).val() )
	# );

	#



	#

	loadTasks()

	displayTasks()


displayTasks = ->

	$('#tasks').empty()

	sTasks = _.sortBy( tasks, (t) -> t.raw )

	row = 1
	for t in sTasks
		html = "
			<div class='task' id='task-#{t.id}'>
				<input type='checkbox' class='task-cb' id='task-cb-#{t.id}'>
				#{t.raw}
			</div>
		"
		$('#tasks').append(html)
		row++


	$('#contexts').empty()
	cContexts = getCounts(contexts)
	uContexts = _.uniq(contexts).sort()
	for c in uContexts
		html = "
			<div class='context sb-item' id='context-#{c}'>
				#{c} #{cContexts[c]}
			</div>
		"
		$('#contexts').append(html)

	#

	$('#projects').empty()
	cProjects = getCounts(projects)
	uProjects = _.uniq(projects).sort()
	for c in uProjects
		html = "
			<div class='project sb-item' id='project-#{c}'>
				#{c} #{cProjects[c]}
			</div>
		"
		$('#projects').append(html)

	#

	$('#tags').empty()
	cTags = getCounts(tags)
	uTags = _.uniq(tags).sort()
	for c in uTags
		html = "
			<div class='tag sb-item' id='tag-#{c}'>
				#{c} #{cTags[c]}
			</div>
		"
		$('#tags').append(html)


loadTasks = ->
	tasks = new Array()
	contexts = new Array()
	projects = new Array()
	tags = new Array()

	d = Ti.Filesystem.getFile( todo_txt_dir, 'todo.txt')
	fs = d.open()

	line = fs.readLine()
	lineNum = 1
	while(line)

		parseTask(lineNum, line)

		line = fs.readLine()
		lineNum++

	fs.close()


parseTask = (lineNum, task) ->

	t = '' + task

	cats = t.match(/@\w+/g)
	if cats
		for c in cats
			contexts.push(c)

	ts = t.match(/#\w+/g)
	if ts
		for t in ts
			tags.push(t)

	pros = t.match(/\+\w+/g)
	if pros
		for p in pros
			projects.push(p)

	priority = t.match(/\([A-Z]\)/)
	# if priority
		# alert(priority)

	tasks.push( {id:lineNum, raw:task, priority:priority} )


saveTasks = ->
	d = Ti.Filesystem.getFile( todo_txt_dir,'todo.txt')
	fs = d.open(Ti.Filesystem.MODE_WRITE)

	for t in tasks
		if t.raw and t.raw.length > 0
			fs.write( t.raw + '\n' )

	fs.close()


addTask = (taskText) ->
	if taskText.length > 0
		$("#add").val('')

		tasks.push( {raw:taskText} )

		saveTasks()
		loadTasks()
		displayTasks()


removeTask = (id) ->
	alert(id)



####

getCounts = (list) ->
	cList = {}
	for c in list
		if !cList[c]
			cList[c] = 0
		++cList[c]
	return cList



init()


