if __FILE__ == $0
   n = Integer(ARGV[1])
   if ARGV[0] == "path"
      puts n
      for i in 1..n-1 do
         print "#{i} #{i+1} "
      end
   elsif ARGV[0] == "cycle"
      puts(n)
      for i in 0..n-1 do 
         print "#{(i)%n+1} "
         print "#{(i+1)%n+1} "
      end
   elsif ARGV[0] == "star"
      puts n
      for i in 2..n do
         print "1 #{i} "
      end
   elsif ARGV[0] == "wheel"
      puts n
      for i in 2..n do
         print "1 #{i} "
      end
      for i in 2..n-1 do 
         print "#{(i)} "
         print "#{(i+1)} "
      end
      print "#{n} 2"
   end
end