#!/usr/bin/perl
open($fh, "< ".$ENV{"HOME"}."/.tempNumb") or die "Failed to open numb file";
while (<$fh>){
	print $_ if (++$count == $ARGV[0]);
}

