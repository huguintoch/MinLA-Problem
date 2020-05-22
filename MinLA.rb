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
  # problem configuration
  vertices = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
  edges = [[7,8],[7,3],[8,12],[8,9],[3,1],[3,4],[12,14],[12,13],[9,11],[9,10],[1,2],[1,0],[4,6],[4,5]]

  # algorithm configuration
  max_iterations = 100
  max_no_improv = 50
  # execute the algorithm
  best = search(vertices, edges, max_iterations, max_no_improv)
  puts "Done. Best Solution: c=#{best[:cost]}, v=#{best[:vector].inspect}"
 end