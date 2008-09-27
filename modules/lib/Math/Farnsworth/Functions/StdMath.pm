package Math::Farnsworth::Functions::StdMath;

use strict;
use warnings;

use Math::Pari;

sub init
{
   my $env = shift;

   $env->{funcs}->addfunc("sin", [],\&sin);
   $env->{funcs}->addfunc("cos", [],\&cos);
   $env->{funcs}->addfunc("tan", [],\&tan);
   $env->{funcs}->addfunc("csc", [],\&csc);
   $env->{funcs}->addfunc("sec", [],\&sec);
   $env->{funcs}->addfunc("cot", [],\&cot);
   $env->{funcs}->addfunc("sinh", [],\&sinh);
   $env->{funcs}->addfunc("cosh", [],\&cosh);
   $env->{funcs}->addfunc("tanh", [],\&tanh);
   $env->{funcs}->addfunc("arcsin", [],\&arcsin);
   $env->{funcs}->addfunc("arccos", [],\&arccos);
   $env->{funcs}->addfunc("arctan", [],\&arctan);
   $env->{funcs}->addfunc("arcsinh", [],\&arcsinh);
   $env->{funcs}->addfunc("arccosh", [],\&arccosh);
   $env->{funcs}->addfunc("arctanh", [],\&arctanh);
   $env->{funcs}->addfunc("abs", [],\&abs);
   $env->{funcs}->addfunc("floor", [],\&floor);
   $env->{funcs}->addfunc("ceil", [],\&ceil);
   $env->{funcs}->addfunc("round", [],\&round);
   $env->{funcs}->addfunc("int", [],\&int);
   $env->{funcs}->addfunc("trunc", [],\&int);
   $env->{funcs}->addfunc("numerator", [],\&numerator);
   $env->{funcs}->addfunc("denominator", [],\&denominator);
   $env->{funcs}->addfunc("random", [],\&random);
   $env->{funcs}->addfunc("randomFloat", [],\&randomFloat);
   $env->{funcs}->addfunc("randomGaussian", [],\&randomGaussian);
   $env->{funcs}->addfunc("min", [],\&min);
   $env->{funcs}->addfunc("max", [],\&max);
   #these functions are simple enough to implement in farnsworth itself, so why not
   $env->eval("sqrt{x} := {x ^ 0.5}"); 
   $env->eval("exp{x} := {var e=2.71828182845904523536; e ^ x}");
   $env->eval("inv{x} := {1/x}"); 
   $env->eval("recip{x} := {1/x}"); 

}
