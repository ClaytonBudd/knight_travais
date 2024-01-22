class Graph
  attr_accessor :nodes

  def initialize
    @nodes = {}
  end

  def add_node(node)
    @nodes[node] = find_edges(node)
  end

  def build_graph(node = [0, 0])
    queue = [node]
    visited = []
    while queue != []
      current = queue.shift
      next if visited.include? current

      edges = add_node(current)
      edges.to_a.each { |e| queue.append(e) }
      visited.append(current) unless visited.include?(current)

    end
  end

  def find_edges(node)
    possible_moves = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]

    legal_moves = []
    possible_moves.each { |a, b| legal_moves.append([node[0] + a, node[1] + b]) }
    legal_moves.select! { |move| move.all? { |d| d > -1 && d < 8 } }
    legal_moves
  end

  def solve(graph, src, dst)
    graph.build_graph

    path = graph.find_path_queue(graph, src, dst)
    length = path.length - 1

    puts 'It took ' + "#{length}" ' moves'
    puts "\n"
    puts 'your path is: '
    puts "#{path}"
  end

  def recursive_flatten(arr)
    arr.each_with_object([]) do |e, a|
      if e.is_a?(Array)
        if e.flatten == e
          a << e
        else
          a.concat(recursive_flatten(e))
        end
      else
        a << e
      end
    end
  end

  def backtrace(parent, src, dst)
    path = [dst]
    while path[-1] != src
      path.append(parent[path[-1]])
      path.reverse
      return path
    end
  end

  def find_path_queue(graph, src, dst)
    queue = [[src]]
    visited = []

    while queue != []
      path = queue.shift
      current = path[-1]

      return recursive_flatten(path) if current == dst

      graph.nodes[current].to_a.each do |edge|
        next if visited.include?(edge)

        new_path = [path]
        new_path.append(edge)
        queue.append(new_path)
      end
      visited.append(current)
    end
  end
end

moves = Graph.new
moves.solve(moves, [3, 3], [4, 3])
