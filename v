#!/usr/bin/perl
if ($ARGV[0]=~/^(.*):(\d+):/) {
	system("/usr/bin/vim \"$1\" +$2");
} else {
	system("/usr/bin/vim", @ARGV);
}

