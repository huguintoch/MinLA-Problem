def cost(permutation, cities, edges)
  distance=0
  edges.each_with_index do |val, i|
    distance += (cities[permutation[val[0]]] - cities[permutation[val[1]]]).abs
  end
  return distance
end

def random_permutation(cities)
  perm = Array.new(cities.size){|i| i}
  perm.each_index do |i|
    r = rand(perm.size-i) + i
    perm[r], perm[i] = perm[i], perm[r]
  end
  return perm
end

def stochastic_two_opt(permutation)
  perm = Array.new(permutation)
  c1, c2 = rand(perm.size), rand(perm.size)
  exclude = [c1]
  exclude << ((c1==0) ? perm.size-1 : c1-1)
  exclude << ((c1==perm.size-1) ? 0 : c1+1)
  c2 = rand(perm.size) while exclude.include?(c2)
  c1, c2 = c2, c1 if c2 < c1
  perm[c1...c2] = perm[c1...c2].reverse
  return perm
end

def local_search(best, cities, edges, max_no_improv)
  count = 0
  begin
    candidate = {:vector=>stochastic_two_opt(best[:vector])}
    candidate[:cost] = cost(candidate[:vector], cities, edges)
    count = (candidate[:cost] < best[:cost]) ? 0 : count+1
    best = candidate if candidate[:cost] < best[:cost]
  end until count >= max_no_improv
  return best
end

def double_bridge_move(perm)
  pos1 = 1 + rand(perm.size / 4)
  pos2 = pos1 + 1 + rand(perm.size / 4)
  pos3 = pos2 + 1 + rand(perm.size / 4)
  p1 = perm[0...pos1] + perm[pos3..perm.size]
  p2 = perm[pos2...pos3] + perm[pos1...pos2]
  return p1 + p2
end

def perturbation(cities, edges, best)
  candidate = {}
  candidate[:vector] = double_bridge_move(best[:vector])
  candidate[:cost] = cost(candidate[:vector], cities, edges)
  return candidate
end

def search(cities, edges, max_iterations, max_no_improv)
  best = {}
  best[:vector] = random_permutation(cities)
  best[:cost] = cost(best[:vector], cities, edges)
  best = local_search(best, cities, edges, max_no_improv)
  max_iterations.times do |iter|
    candidate = perturbation(cities, edges, best)
    candidate = local_search(candidate, cities, edges, max_no_improv)
    best = candidate if candidate[:cost] < best[:cost]
    puts " > iteration #{(iter+1)}, best=#{best[:cost]}"
  end
  return best
end

if __FILE__ == $0
  if ARGV.length > 1
    numVertices = Intger(ARGV[0])
    edgesString = ARGV[1]
    edgesArray = edgesString.split(" ")
  else
    input = ARGF.read
    splitedInput = input.split("\n")
    numVertices = Integer(splitedInput[0])
    edgesString = splitedInput[1]
    edgesArray = edgesString.split(" ")
  end

  #problem configuration
  vertices = []
  for i in 0..numVertices-1 do 
    vertices.push(i+1)
  end 

  if edgesArray.length%2 == 0 
    edges = [[]]
    for i in 0..(edgesArray.length-1)/2 do
      edges.push([Integer(edgesArray[i*2])-1], [Integer(edgesArray[i*2+1])-1])
    end

    puts edges

    # # algorithm configuration
    # max_iterations = 1000
    # max_no_improv = 50
    # # execute the algorithm
    # best = search(vertices, edges, max_iterations, max_no_improv)
    # puts "Done. Best Solution: c=#{best[:cost]}, v=#{best[:vector].inspect}"
  else
    puts "Se recibió una arista incompleta"
  end
 end