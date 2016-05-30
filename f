#!/usr/bin/perl
$search = "find . -iname \"".$ARGV[0]."\"";
print `$search`;

