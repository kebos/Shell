#!/usr/bin/perl
$search = "grep --color=always -Irni \"".$ARGV[0]."\" .";
print `$search`;

