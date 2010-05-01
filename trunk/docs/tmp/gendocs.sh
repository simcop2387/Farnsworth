#!/bin/bash

for i in `find ../../lib/ -iname \*.pm `; 
	do DIRNAME="`dirname $i | perl -pe 's|../../lib/||; $_=lc $_;'`"; 
	FNAME="`basename $i | perl -pe 's/\.pm/.html/; $_=lc $_;'`"; 
	mkdir -p $DIRNAME; 
	pod2html --htmldir=../docs/tmp --htmlroot=/docs --recurse --infile $i > $DIRNAME/$FNAME.orig; 
	perl -MHTML::TreeBuilder -le 'my $tree = HTML::TreeBuilder->new_from_file( shift ); my $body=$tree->look_down( _tag => "body" ); my @links=$body->look_down(_tag => "a" ); for (@links) {my $href=$_->attr("href"); $href=lc $href if $href =~ /\.html$/i; $href=~s/\.html$//i; $_->attr("href", $href);}; for ($body->content_list()) {print $_->as_HTML() if ref($_) && $_->can("as_HTML")}' $DIRNAME/$FNAME.orig > $DIRNAME/$FNAME;
 done
find -iname \*.orig -exec rm -- {} \;
find -iname \*.html -exec md5sum {} \; | grep 4b105f6a9f0384fbbe67e62d3a5ccc0d | awk '{print $2}' | xargs rm --
