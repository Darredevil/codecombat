class QuadTree

	###
		bounds =  object representing the bounds of the top level of the QuadTree. The object 
		should contain the following properties : x, y, width, height
		pointQuad = (Boolean) use it as TRUE for now
		maxDepth = The maximum number of levels that the quadtree will create. Default is 4.
		maxChildren = The maximum number of children that a node can contain before it is split into sub-nodes.
	###
	constructor: (bounds,pointQuad,maxDepth,maxChildren) ->
		node = undefined
		if pointQuad
			node = new Node(bounds, 0, maxDepth, maxChildren)
		#TODO
		#else
		#	node = new BoundsNode(bounds, 0, maxDepth, maxChildren)
		@root = node
		return

	insert: (item) ->
		if item instanceof Array
			len = item.length
			i = 0
			while i < len
				@root.insert item[i]
				i++
		else
			@root.insert item
		return
		
	clear: ->
		@root.clear()
		return

	# Retrieves all items / points in the same node as the specified item / point. If the specified item
	# overlaps the bounds of a node, then all children in both nodes will be returned.
	retrieve: (item) ->
		out = @root.retrieve(item).slice(0)
		out

class Node

	constructor: (bounds, depth, maxDepth, maxChildren) ->
		@_bounds = bounds
		@children = []
		@_depth = 0
		@_maxChildren = 4
		@_maxDepth = 4
		@nodes = []

		@TOP_LEFT = 0
		@TOP_RIGHT = 1
		@BOTTOM_LEFT = 2
		@BOTTOM_RIGHT = 3

		if maxChildren
			@_maxChildren = maxChildren
		if maxDepth
			@_maxDepth = maxDepth
		if depth
			@_depth = depth
		return


	insert: (item) ->
		if @nodes.length
			index = @findIndex(item)
			@nodes[index].insert item
			return
		@children.push item
		len = @children.length
		if !(@_depth >= @_maxDepth) and len > @_maxChildren
			@subdivide()
			i = 0
			while i < len
				@insert @children[i]
				i++
			@children.length = 0
		return

	retrieve: (item) ->
		if @nodes.length
			index = @findIndex(item)
			return @nodes[index].retrieve(item)
		@children

	findIndex: (item) ->
		b = @_bounds
		left = if item.x > b.x + b.width / 2 then false else true
		top = if item.y > b.y + b.height / 2 then false else true
		#top left
		index = Node.TOP_LEFT
		if left
			#left side
			if !top
				#bottom left
				index = Node.BOTTOM_LEFT
		else
			#right side
			if top
				#top right
				index = Node.TOP_RIGHT
			else
				#bottom right
				index = Node.BOTTOM_RIGHT
		index

module.exports = QuadTree
