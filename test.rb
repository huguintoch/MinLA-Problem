if ARGV.length > 1
   puts ARGV[0]
   puts ARGV[1]
 else
   input = ARGF.read
   splitedInput = input.split("\n")
   puts splitedInput[0]
   puts splitedInput[1]
 end