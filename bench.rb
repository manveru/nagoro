if ARGV[0] == 'run'
  eval DATA.read
  exit
end

require 'benchmark'

engine = ENV['NAGORO_ENGINE']

Benchmark::bmbm(20) do |b|
  b.report("REXML: ") do
    ENV['NAGORO_ENGINE'] = 'rexml'
    system("ruby #{__FILE__} run")
  end

  b.report("libxml: ") do
    ENV['NAGORO_ENGINE'] = 'libxml'
    system("ruby #{__FILE__} run")
  end
end

ENV['NAGORO_ENGINE'] = engine

__END__
require 'nagoro'
nagoro = Nagoro::Template[:Element, :Morph, :Include, :Instruction]
string = '<html><div times="100"><?r a = 1 ?>#{a}</div></html>'
n = 1_000
n.times do
  nagoro.render(string)
end
