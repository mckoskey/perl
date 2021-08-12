#!/usr/bin/perl
use strict;
use warnings;
use lib qw(c:/bin/perl /home/mckoskey/bin/perl);

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

	if($filename !~ /\.ly/)
	{
		$filename = $filename . ".ly";
	}

	if(-e $filename)
	{
		print "File \"" . $filename . "\" exists, skipping...\n";
		next;
	}

	my $file = IO::File->new($filename, ">") or croak "Unable to open \"" . $filename . "\": " . $OS_ERROR;

	print $file "% Document: " . $filename . "\n";
	print $file "% Date: " . $util->get_print_date() . "\n";
	print $file "% Author: David McKoskey\n";
	print $file "%\n";
	print $file "\n";

	close($file);

	print "\t\"" . $filename . "\" created.\n";
}

sub Syntax
{
	print "\n";
	print "\tSyntax: lilypond <filename(s)>\n";
	print "\n";
	print "\tNote: do not use wildcards\n";
	print "\n";
	exit -1;
}
