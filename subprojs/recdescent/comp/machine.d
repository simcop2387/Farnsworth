# opcode implementation

halt   die "halt\n"

load   $acc = $mem[$addr] + 0
store  $mem[$addr] = $acc

add    $acc += $mem[$addr]
sub    $acc -= $mem[$addr]
mul    $acc *= $mem[$addr]
div    $acc /= $mem[$addr]
mod    $acc %= $mem[$addr]
chs    $acc = -$acc

jump   $pc = $addr
jf     $pc = $addr if $acc == 0
jt     $pc = $addr if $acc != 0

gt     $acc = $acc > $mem[$addr] ? 1 : 0
lt     $acc = $acc < $mem[$addr] ? 1 : 0
eq     $acc = $acc == $mem[$addr] ? 1 : 0
ne     $acc = $acc != $mem[$addr] ? 1 : 0
ge     $acc = $acc >= $mem[$addr] ? 1 : 0
le     $acc = $acc <= $mem[$addr] ? 1 : 0

input  print STDERR "enter input: "; $acc = 0 + <>
output print STDERR "output: $acc\n"
