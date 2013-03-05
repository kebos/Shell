#!/usr/bin/perl
print "Installer for default setup\n";
setup();

eval{appendFile("$ENV{HOME}/.bashrc", "PSOBEKAPPEND", $bashrcExtra)};
eval{appendFile("$ENV{HOME}/.vimrc", "PSOBEKAPPEND", $vimrcExtra)};

print "Creating vim, mvim and cdh\n";
$base = $ENV{HOME};
`mkdir "$base/bin"`;
createFile("$base/bin/vim", $vimExtra);
createFile("$base/bin/mvim", $mvimExtra);
createFile("$base/bin/cdh", $cdhExtra);
print "Creating hilite program\n";
open my $fh, "| gcc -x c - -o \"$ENV{HOME}/bin/hilite\"";
print $fh $hiliteProg;
close $fh;

print "All done\n";

sub createFile(){
  $target = shift;
	$contents = shift;
	open($fh, ">$target") or die "Failed to open file $target";
	print $fh $contents;
	close $fh;	
	`chmod +x "$target"`;
}

sub appendFile(){
	$target = shift;
	$checkString = shift;	
	$contents = shift;
	
	# First check if we have already appended to bashrc
	if (-e "$target"){
		open($fh, "$target");		
		while(<$fh>){
			die "Already added $target\n" if (/$checkString/);
		}
		close $fh;
	}

	# Append to bash rc
	print "Appending to $target";
	open($fh, "| cat >> \"$target\"") or die "Couldn't append to $target";
	print $fh $_ for ($contents);
	close $fh;
}

sub setup(){
our $vimrcExtra = <<'VIMRC';
" PSOBEKAPPEND
set ignorecase
set number
set smartcase
set hlsearch
set nowrapscan
if has("cscope")

    """"""""""""" Standard cscope/vim boilerplate

    set cscopetag
    set csto=0

    let curdir = getcwd()

    while !filereadable("cscope.out") && getcwd() != "/"
        cd ..
    endwhile

    if filereadable("cscope.out")
        execute "cs add " . getcwd() . "/cscope.out " . getcwd() . ""
    endif

    execute "cd \"" . curdir."\""

    set cscopeverbose  


    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	

    nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
    nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
    nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>



endif

set nowrapscan
 
VIMRC
our $bashrcExtra = <<'BASHRC';
# PSOBEKAPPEND
export PATH=$HOME/bin:$PATH
cdhistory(){
        cd $@
        cdh
}
cdhGo(){
        cd "$(cdh g $@)"
        cdh
}
alias cd=cdhistory
alias cdg=cdhGo
BASHRC

our $vimExtra = <<'VIMEXTRA';
#!/usr/bin/perl
if ($ARGV[0]=~/^(.*):(\d+):/) {
	system("/usr/bin/vim \"$1\" +$2");
} else {
	system("/usr/bin/vim", @ARGV);
}
VIMEXTRA

our $mvimExtra = <<'MVIMEXTRA';
#!/usr/bin/perl
my @arr; push(@arr, $_) while (<>); (/^(.*):(\d+):/) ? system("/usr/bin/vim", $1, "+$2") : system("/usr/bin/vim", $_) for (@arr);
MVIMEXTRA

our $cdhExtra = <<'CDHEXTRA';
#!/usr/bin/perl
use Fcntl qw(:flock);
$MAXSIZE = 400;
$PRINTSIZE = 35;
$logFile = "$ENV{HOME}/.cdh";
$loc = `pwd`;


# List directories, mru will be at bottom

if ($ARGV[0] eq "l"){
        $PRINTSIZE = $MAXSIZE if ($ARGV[1] eq "a");
        open($fh, "<$logFile") or exit;
        flock($fh, LOCK_SH) or die "Couldn't lock file";
	$i = 0;
        while (<$fh>){
                print "". $i . " " . $_;
                exit if ($i++ > $PRINTSIZE);
                <$fh>;
        }
        exit;
}elsif ($ARGV[0] eq "ll"){
        $PRINTSIZE = $MAXSIZE if ($ARGV[1] eq "a");
        open($fh, "<$logFile") or exit;
        flock($fh, LOCK_SH) or die "Couldn't lock file";
	$i = 0;
        while (<$fh>){
                print "". $i . " " . $_;
		$i++;
                <$fh>;
        }
        exit;
}elsif ($ARGV[0] eq "g"){
	$line = $ARGV[1] + 0;
	open($fh, "<$logFile") or exit;
        flock($fh, LOCK_SH) or die "Couldn't lock file";
        while (<$fh>){
		if ($i++ == $line){
			print "$_";
			exit 0;
		}
                <$fh>;
        }
	close $fh;
	exit;
}elsif ($ARGV[0] eq "r"){# Clear directory history
        `rm "$logFile"` if (-e $logFile);
        exit;
}elsif (!$ARGV[0]){}else{
	print "Invalid commands, accepts l (list) g (print #) and r (reset list)\n";
}

# Read in directory history
if (open($fh, "<$logFile")){
        flock($fh, LOCK_SH) or die "Couldn't lock file";
        while(<$fh>){
                $timestamp = <$fh>;
                chomp($timestamp);
                $cdh{$_} = $timestamp;
        }
        close ($fh);
}

$cdh{$loc} = time();
@evict = sort {$cdh{$b} <=> $cdh{$a} } (keys %cdh);
pop @evict if ($#evict > $MAXSIZE);

#Write out log file again
open($fh, ">$logFile") or die "Couldn't write";
flock($fh, LOCK_EX) or die "Couldn't lock file";;
for(@evict){
        print $fh $_;
        print $fh $cdh{$_} . "\n";
}
close($fh);
CDHEXTRA

our $hiliteProg= <<'END';

/*
 * hilite - runs a command, highlighting everything it sends to stderr
 * version 1.5
 *
 * Copyright (C) 2000, 2001  Mike Schiraldi <mgs21@columbia.edu>
 *
 * See www.sf.net/forum/forum.php?forum_id=104071 for news and info
 *
 * Or just www.sf.net/projects/hilite if the above link is no good
 *
 */

/*
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program, but Mike's a lazy bastard. To get one,
 * write to the Free Software Foundation, Inc., 59 Temple Place - Suite
 * 330, Boston, MA 02111-1307, USA.
 */

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/wait.h>

#define HEADER "\033[91m"
#define FOOTER "\033[0m"

#define FAIL(msg) { fprintf (stderr, "%s: " msg "() failed: %s\n", argv[0], \
                              strerror (errno)); return 1; }

int
main (int argc, char **argv)
{
  int p[2];
  int f;

  if (argc < 2)
    {
      fprintf (stderr, "%s: specify a command to execute\n", argv[0]);
      return 1;
    }

  if (pipe (p) != 0)
    FAIL ("pipe");

  f = fork ();

  if (f == -1)
    FAIL ("fork");

  if (f)
    {
      int status;

      close (p[1]);

    again:
      errno = 0;

      while (1) 
        {
          int r;
          char buf[BUFSIZ];

	  r = read (p[0], buf, BUFSIZ - 1);

	  if (r <= 0)
            break;

          buf[r] = 0;
          fprintf (stderr, "%s%s%s", HEADER, buf, FOOTER);
	}

      if (errno == EINTR) 
        {
          fprintf (stderr, "%s: read interrupted, trying again\n", argv[0]);
          goto again;
        }

      if (errno != 0) 
          FAIL ("read");

      if (wait (&status) != f)
          FAIL ("wait");
      
      return WEXITSTATUS (status);
    }
  else
    {
      int fd;

      close (p[0]);
      close (fileno (stderr));

      fd = dup (p[1]); /* dup() uses the lowest available fd, which should be stderr's 
                        * since we just closed it */

      /* Can't use stderr for these problems, since we just closed it */
      if (fd < 0)
	{
	  printf ("%s: dup() failed: %s\n", argv[0], strerror (errno));
	  return 1;
	}

      if (fd != fileno (stderr))
        {
	  printf ("%s: dup returned %d instead of %d\n", argv[0], fd, 
                  fileno (stderr));
          return 1;
        }

      execvp (argv[1], &argv[1]);

      FAIL ("exec");
    }
}
END


}


my $user = $ENV{"USER"};
print "\nsudo bash -c \"$user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers\"\n
