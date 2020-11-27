# encoding: cp852

# Run:
#   ruby print_enc.rb abc äöüЖあ𝄞


# in rubyinstaller2/packages/rubyinstaller/recipes/compile/ruby-2.4.1/src/build-x86_64-w64-mingw32
# $ make ruby.exe
# $ ruby --disable=gems -I .ext/x64-mingw32 print_enc.rb a

# Encoding.default_external = 'utf-8'

# STDIN = $stdin = IO.new(STDIN.fileno,
#     external_encoding: Encoding.find('locale'), internal_encoding: 'utf-8',
#     undef: :replace, invalid: :replace)
# STDOUT = $stdout = IO.new(STDOUT.fileno, "w",
#     external_encoding: Encoding.find('locale'), internal_encoding: 'utf-8',
#     undef: :replace, invalid: :replace)

def print(*strs)
  Kernel.print *strs
  File.open("#{$0}.out", "a+"){|fd| fd.print *strs }
end

def exec(text, b=binding)
  print text
  print ": "
  res = eval text, b
  print res
  print "\n"
end

ustr = "\u00E4\u0416\u{3042}\u{1d11e}"  # äЖあ𝄞
ENV['TESTUNICODE1'] = "abcäöü"
ENV['TESTUNICODE2'] = ustr

exec "__ENCODING__"
exec "Encoding.default_external"
exec "Encoding.default_internal"
exec "Encoding.find 'locale'"
exec "Encoding.find 'filesystem'"
exec "STDIN.external_encoding"
exec "STDIN.internal_encoding"
exec "STDOUT.external_encoding"
exec "STDOUT.internal_encoding"
exec "ARGV.map{|s| [s, s&.encoding.name] }"
exec "[ENV['USERNAME'], ENV['TESTUNICODE1'], ENV['TESTUNICODE2']].map{|s| [s, s&.encoding.name] }"

Dir["abc*.enco"].each{|f| File.unlink(f) }
print "puts ustr : "; puts ustr
print "p ustr : "; p ustr

File.write("abc.enco", ustr)
File.write("abc#{ustr}.enco", ustr)
dir = Dir["abc*.enco"]
exec "[dir, dir.map(&:encoding)]", binding
