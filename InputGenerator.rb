if __FILE__ == $0
   n = Integer(ARGV[1])
   if ARGV[0] == "path"
      puts n
      for i in 1..n-1 do
         print "#{i} #{i+1} "
      end
   elsif ARGV[0] == "cycle"
      print(n)
   elsif ARGV[0] == "star"
      print(n)
   end
end