if ARGV[0] == 'run'
  eval DATA.read
  exit
end

require 'benchmark'

engine = ENV['NAGORO_ENGINE']

Benchmark::bmbm(20) do |b|
  %w[rexml libxml stringscanner].each do |engine|
    b.report("#{engine}: ") do
      ENV['NAGORO_ENGINE'] = engine
      system("ruby #{__FILE__} run")
    end
  end
end

ENV['NAGORO_ENGINE'] = engine

__END__
require 'nagoro'
string = '<html><div times="100"><?r a = 1 ?><?ro a ?></div></html>'
n = 1_000
n.times do
  Nagoro.render(string)
end
