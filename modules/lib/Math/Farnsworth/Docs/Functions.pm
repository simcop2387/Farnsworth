1;
__END__
=head1 NAME

Math::Farnsworth::Functions - A big reference to all the functions in the Math::Farnsworth Standard Library 

=head1 DESCRIPTION

This document is intended to document all of the functions that Math::Farnsworth includes in its standard library.

=head1 Array Functions

=head2 push[]

	push[array, elements, ...]

Push will take an array and place all arguments following the array onto the end.  Just like a C<stack>.

=head2 pop[]

	result = pop[array]

Pop is the antithesis (ED NOTE: need better word!) to push, instead of placing an element on the end of the array, pop[] removes it.

=head2 unshift[]

	unshift[array, elements, ...]

Unshift is very similar to pop[].  However instead of putting the elements on the end of the array; unshift puts them at the beginning.

=head2 shift[]

	shift[array]

Just as pop is the antithesis (ED NOTE: need better word, STILL!) to push, shift[] is the antithesis to unshift[]

=head2 sort[]

	sortedarray = sort[elements, ... ]
	sortedarray = sort[array]
	sortedarray = sort[{`a,b` a <=> b}, elements, ... >]
	sortedarray = sort[{`a,b` a <=> b}, array]

sort[] will take a series of numbers or strings and sort them into either alphabetical or numerical order.
If you give a lambda as the first argument to sort[] it will use that to do all of the logic for comparing each element of the array.
This lambda must perform the comparison in a stable manner or the results will not be deterministic.  The lambda must take two arguments and then return either a -1, 0, or 1 as the B<E<lt>=E<gt>> operator does.

=head2 map[]

	mappedarray = map[maplambda, array]
	mappedarray = map[maplambda, elements, ...]
	mappedarray = map[{`x` x + 10}, array]
	mappedarray = map[{`x` x + 10}, elements, ...]

map[] will take an array or set of elements and pass each element as the first argument to B<maplambda> for B<maplambda> to transform.
B<maplambda> should return the new value for the element to be used in B<mappedarray>.

=head2 length[]

	howmany = length[array]

When you give length[] and array, it will return how many elements the array has.

=head2 reverse[]

	reversedarray = reverse[array]

reverse[] will reverse the order of the elements in array and return the result.

=head1 String Functions

=head2 reverse[]

	reversedstring = reverse[string]

reverse[] will reverse the order of all the characters in the string.

=head2 length[]

	howlong = length[string]

When length[] take either a string as its argument it will return the length of the string in characters, this means that a string with unicode characters like B<"日本語"> will have a length of B<3>.

=head2 ord[]

	codepoint = ord[string]

ord[] will give you the unicode codepoint of the first character of the string you pass it.

=head2 chr[]

	string = chr[codepoint]

chr[] will take a unicode codepoint and give you back a string containing only that character.

=head2 index[]

	position = index[string, substring]
	position = index[string, substring, pos]

index[] will search in B<string> for the first occurance of B<substring> and return its B<position>.  If B<substring> is not found in B<string> it will return -1.
The optional parameter B<pos> will tell index how far into the string to start looking, 0 being the start of the string.

=head2 eval[]

	result = eval[string]

eval[] will take a string and evaluate it as if it were the Math::Farnsworth language and return the result.

=head2 substrLen[]

	substring = substrLen[string, start, length]

substrLen[] will pull out a part of B<string> that starts at B<start> and is B<length> characters.  If B<length> is longer than the end of B<string> then it will B<substring> will only contain the text up until the end of the string.

=head2 substr[]

	substring = substr[string, start, end]

substr[] will pull out a part of B<string> that starts at B<start> and ends at B<end>

=head2 left[]

	substring = left[string, length]

left[] returns the left 'B<length>' characters from 'B<string>'.

=head2 right[]

	substring = right[string, length]

right[] returns the right 'B<length>' characters from 'B<string>'.

=head1 Math Functions

=head2 Trigonometry Functions

	sin[]   csc[]
	cos[]   sec[]
	tan[]   cot[]
	atan[] 	arctan[]
	acos[] 	arccos[]
	asin[] 	arcsin[]

	sinh[]
	cosh[]
	tanh[]
	atanh[] arctanh[]
	acosh[] arccosh[]
	asinh[] arcsinh[]

I will not go into a detailed explination of what these functions are.  They are the basic trigonometric functions, they all take a single number in and return the result.

=head2 Miscellaneous Math Functions

	abs[]
	floor[] ceil[]
	int[] trunc[]

=head2 Complex Number Math Functions

	conj[x] # conjugate
	norm[x] # normal
	real[x] # gives back the real part of a complex number
	imag[x] # gives back the imaginary part of a complex number


=head1 Miscellaneous Functions

=head2 now[]

	now[]

now[] returns the current date and time as a Math::Farnsworth Date value.

=head2 unit[]

	unit[unit]

unit[] takes the name of a unit B<NOT> as a string (in future releases it will take it as a string or barename), and will always return the value of the unit[] named as such.  This allows you to have access to a unit even when someone has carelessly defined a variable that stomps on that unit.
