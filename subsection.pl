#!/usr/bin/perl
#
# Name: subsection.pl
# Date: 14 June, 2011
# Author: David McKoskey



use strict;
use warnings;
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use IO::File;
use Utilities;

if($#ARGV < 0) { Syntax(); }

my $util = new Utilities();
my $today = $util->get_print_date();

my @infiles = @ARGV;

foreach my $filename (@infiles)
{
	if($filename =~ /\*/)
	{
		print"\n\tERROR: WILDCARD.  Please enumerate file names\n\n";
		Syntax();
	}

	if(-e $filename)
	{
		print "File \"" . $filename . "\" exists, skipping...\n";
		next;
	}

	if($filename !~ /\.tex/)
	{
		$filename = $filename . ".tex";
	}

	if(-e $filename)
	{
		print "File \"" . $filename . "\" exists, skipping...\n";
		next;
	}

	my $file = IO::File->new($filename, ">") or croak "Unable to open \"" . $filename . "\": " . $OS_ERROR;

	print $file "% " . $util->get_print_date() . "\n";
    print $file "% \\subsection[" . $util->get_title($filename) . "]{" . $util->get_title($filename) . "}\\label{subsec:" . $util->get_label ($filename) . "}\n";
	print $file "\\subsection{" . $util->get_title($filename) . "}\n";
	print $file "\n";
	print $file "\n";

	close($file);

	print "\t\"" . $filename . "\" created.\n";
}


sub Syntax
{
	print "\n";
	print "\tSyntax: subsection <filename(s)>\n";
	print "\n";
	print "\tNote: do not use wildcards\n";
	print "\n";
	exit -1;
}

#
# end script
#
