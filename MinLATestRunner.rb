def cost(permutation, vertices, edges)
  distance = 0
  edges.each_with_index do |val, i|
    distance += (vertices[permutation[val[0]]] - vertices[permutation[val[1]]]).abs
  end
  return distance
end

def random_permutation(vertices)
  perm = Array.new(vertices.size){|i| i}
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

def swap(permutation)
  perm = Array.new(permutation)
  c1, c2 = rand(perm.size), rand(perm.size)
  temp = perm[c1]
  perm[c1] = perm[c2]
  perm[c2] = temp
  return perm
end

def local_search(best, vertices, edges, max_no_improv)
  count = 0
  begin
    candidate = {:vector=>stochastic_two_opt(best[:vector])}
    candidate[:cost] = cost(candidate[:vector], vertices, edges)
    count = (candidate[:cost] < best[:cost]) ? 0 : count+1
    best = candidate if candidate[:cost] < best[:cost]
  end until count >= max_no_improv
  return best
end

def local_search_first_improv(best, vertices, edges, max_no_improv)
  count = 0
  begin
    candidate = {:vector=>stochastic_two_opt(best[:vector])}
    candidate[:cost] = cost(candidate[:vector], vertices, edges)
    count = count+1
    if candidate[:cost] < best[:cost]
      best = candidate
    end
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

def perturbation(vertices, edges, best)
  candidate = {}
  candidate[:vector] = double_bridge_move(best[:vector])
  candidate[:cost] = cost(candidate[:vector], vertices, edges)
  return candidate
end

def search(vertices, edges, max_iterations, max_no_improv)
  best = {}
  best[:vector] = random_permutation(vertices)
  best[:cost] = cost(best[:vector], vertices, edges)
  best = local_search(best, vertices, edges, max_no_improv)
  max_iterations.times do |iter|
    candidate = perturbation(vertices, edges, best)
    candidate = local_search(candidate, vertices, edges, max_no_improv)
    best = candidate if candidate[:cost] < best[:cost]
    # puts " > iteration #{(iter+1)}, best=#{best[:cost]}"
  end
  return best
end

def variance(x, m)
  sum = 0.0
  x.each {|v| sum += (v-m)**2 }
  sum/x.size
end

def sigma(x, m)
  Math.sqrt(variance(x, m))
end

if __FILE__ == $0
  valid = true
  # if ARGV.length > 1
  #   numVertices = Integer(ARGV.shift)
  #   edgesArray = ARGV
  # else
  correct_result = Integer(ARGV.shift)
  input = ARGF.read
  splitedInput = input.split("\n")
  numVertices = Integer(splitedInput[0])
  edgesString = splitedInput[1]
  edgesArray = edgesString.split(" ")
  # end

  vertices = []
  for i in 0..numVertices-1 do 
    vertices.push(i+1)
  end 

  if edgesArray.length%2 == 0 
    edges = []
    for i in 0..(edgesArray.length-1)/2 do
      element1 = Integer(edgesArray[i*2])-1
      element2 = Integer(edgesArray[i*2+1])-1
      a = element1, element2
      edges.push(a)
    end

    # algorithm configuration
    max_iterations = 100
    max_no_improv = 1000
    # execute the algorithm
    puts "Respuesta correcta: #{correct_result}"
    puts "Iteracion, Resultado, Tiempo, Error"
    resSum = 0
    timeSum = 0
    errorSum = 0
    results = Array.new
    errors = Array.new
    for i in 0..49
      start = Time.now
      best = search(vertices, edges, max_iterations, max_no_improv)
      finish = Time.now
      # for i in 0..best[:vector].length-1 do 
      #   print "#{best[:vector][i]} "
      # end
      resSum += best[:cost]
      timeSum += finish-start
      results.push(best[:cost])
      error = (((correct_result-best[:cost]).abs)/correct_result.to_f)*100
      errorSum += error
      puts "#{i+1},#{best[:cost]},#{finish-start},#{error}"
    end
    puts ""
    puts "Mejor Resultado: #{results.min}"
    res_promedio = resSum/50
    puts "Resultado Promedio: #{resSum/50.0}"
    puts "Desviacion Estandar: #{sigma(results, res_promedio)}"
    puts ""
    puts "Tiempo Promedio: #{timeSum/50.0}"
    puts "Error Promedio: #{errorSum/50.0}"
  else
    puts "Se recibió una arista incompleta"
  end
 end

# *** AUTORES ***
# Emilio Castillo Alegría A01631303
# Hugo Isaac Valdez Ruvalcaba A01631301
# Guillermo Hiroshi Tanamachi Ortega A01631327
# José Adrián Lozano Domínguez A01631017

# *** REFERENCIAS ***
# Código basado en:
# http://www.cleveralgorithms.com/nature-inspired/stochastic/iterated_local_search.html