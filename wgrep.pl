#!/usr/bin/perl
#
# Name: wgrep.pl
# Date: 12 July, 1999
# Author: David McKoskey

use strict;
# use warnings;

use Cwd;
use File::Find;
use File::Path;
use Getopt::Std;
use vars qw($opt_a $opt_b $opt_f $opt_i $opt_l $opt_n $opt_p $opt_r);
getopts('abfilnpr');

my($start, $end);
my(@infiles, @file_array);
my %file_names;
my($file);
my ($cwd, @filepatterns);
my($index, $i);
my($window, $pattern);
my $match = 0;
my $lineno = -1;
my($err, $file_array_size);

# case sensitivity
if ($opt_i) { $pattern = "(?i)$ARGV[0]"; }
else { $pattern = "$ARGV[0]"; }

if($ARGV[1] !~ /\D/) { $window = $ARGV[1]; }
if ($window ne "") { shift; } shift; # shift pattern / window out of ARGV

if ($#ARGV < 0) { syntax (); exit 0; } # require two parameters

if($opt_r)
{
	$cwd = cwd();
	@filepatterns = split /\*/, $ARGV[0];
	find(\&findFiles, ".");

	if($opt_p == 1)
	{
		foreach my $file_name (sort keys %file_names)
			{ print $file_name . "\n"; }
	}

	undef %file_names;
}
else
{
	foreach $file (<$ARGV[0]>) { processFiles($file); }

	if($opt_p)
	{
		foreach my $file_name (sort keys %file_names)
			{ print $file_name . "\n"; }
	}

	undef %file_names;
}


=pod

=head4 findFiles()

Find the files to search.

=cut
sub findFiles
{
	my $file = $File::Find::name;
	if(! -d $file && hasPattern($file)) { processFiles($file); }
}


=pod

=head4 hasPattern()

Determine whether or not a line contains a desired pattern (regular expression).  

=cut
sub hasPattern
{
	foreach my $pattern (@filepatterns)
	{
		if($_[0] !~ /$pattern$/) { return 0; }
	}

	return 1;
}


=pod

=head4 processFiles()

Process input files.  

=cut
sub processFiles
{
	if($opt_r) { $file = $cwd . substr($_[0], 1); }
	else { $file = $_[0]; }

	$err = open (FILE, "$file");
	if ($err == 0)
	{
        # print( "\n\tCannot open \"$file\", skipping...\n\n");
		next;
	}

	@file_array = <FILE>;
	$file_array_size = $#file_array + 1;

	for ($index = 0; $index < $file_array_size; $index++)
	{
		if ($file_array[$index] =~ /$pattern/)
		{ 
			if($opt_p)
			{
				$file_names{$file} = 1;
				next;
			}

			$match = 1;

 			# where to start
			if ($index - $window <= 0) { $start = 0; }
			else { $start = $index - $window; }

 			# where to end
			if ($index + $window > $file_array_size) { $end = $file_array_size; }
			else { $end = $index + $window + 1; }

			if ($opt_a) { $start = $index; }      # show only after
			if ($opt_b) { $end = $index + 1; }    # show only before

			for ($i = $start; $i <  $end; $i++)   # display lines
			{
				if ($opt_f)
				{
					if ($opt_n) { $lineno = $i + 1; print "$lineno: "; }
				}
				else
				{
					if ($opt_n) { $lineno = $i + 1; print "$file $lineno: "; }
					else { print "$file: "; }
				}

				print "$file_array[$i]";
			}
		}

		if ($match == 1 && defined($opt_l) && $opt_l) { print "\n"; $match = 0; }
	}

	close(FILE);
}


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub syntax
{
	printf ("\n\t wgrep: windowed grep\n");
	printf ("\n\t Syntax: wgrep [\-abfiln] \<pattern\> \<number\> \<file\>\n");
	printf ("\t        pattern = string to search for\n");
	printf ("\t                  in double quotes\: \"string\"\n");
	printf ("\t        number = window size; number of lines\n");
	printf ("\t                  above and below the line.\n");
	printf ("\t        options:  \-a  show only lines after pattern\n");
	printf ("\t                  \-b  show only lines before pattern\n");
	printf ("\t                  \-f  suppress printing file name\(s\)\n");
	printf ("\t                  \-p  suppress printing pattern (print file name\)\n");
	printf ("\t                  \-i  ignore case \n");
	printf ("\t                  \-l  print a blank line between finds\n");
	printf ("\t                  \-n  print window line numbers\n");
	printf ("\t                  \-r  process all files in tree\n");
	printf ("\n");
}


=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
