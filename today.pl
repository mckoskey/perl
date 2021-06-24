#!/usr/bin/perl
#
# Name: today.pl
# Date: 24 May, 2001
# Author: David McKoskey


use strict;
use warnings;
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use IO::File;
use Getopt::Std;
use Utilities;
use vars qw($opt_i);
getopts('i:');

# print "Current day and time: " . (scalar localtime) . "\n";

my $util = new Utilities();
# my $prefix = shift @ARGV;
# $prefix = 'sketch' unless defined($prefix) && length($prefix) > 0;
my $today = $util->get_print_date();
my $short_today = $util->get_short_date();
# my $filename = $prefix . "_" . $util->get_file_date() . ".tex";
my $filename = $util->get_file_date() . ".tex";

if(! -e $filename)
{
	my $file = IO::File->new($filename, ">") or croak "Unable to create \"" . $filename . "\": " . $OS_ERROR;

	print $file "\\subsection[". $short_today . "]{" . $today . "}\\label{subsec:" . $short_today . "}\n";
	print $file "\n";
	print $file "\n";
	print $file "\n";
	print $file "\n";
	print $file "% \\noindent\\makebox[\\linewidth]{\\rule{\\paperwidth}{0.4pt}} % Horizontal line\n";
	print $file "% \\begin{center} \\noindent\\makebox[\\linewidth]{\\rule{4in}{0.4pt}} \\end{center} % Horizontal segment\n";
	print $file "\n";
	print $file "\n";
	print $file "\n";
	print $file "\n";

	if(defined($opt_i)) # optionally inline another file (additional subsections, etc.)
	{
		if(-e $opt_i)
		{
			my $infile = IO::File->new($opt_i, "<") or croak "Unable to create \"" . $opt_i . "\": " . $OS_ERROR;

			while(my $inline = <$infile>) { print $file $inline; }

			close($infile);
		}
		else { print "Error: unable to inline \"" . $opt_i . "\" into file.\n"; }
	}
	else { print $file "\n"; }

	close($file);
}

# system("start gvim $filename");
system("gvim $filename &");

=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
