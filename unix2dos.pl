#!/usr/bin/perl
#
# Name: unix2dos
# Date: 18 April, 2005
# Author: David McKoskey



if($#ARGV < 0) { Syntax(); }

use strict;
use Carp;
use English;
use IO::File;
use File::Copy;

  my @infilenames = @ARGV;
  my $tempfilename = "/tmp/mckoskey_temp.txt";

# my @infilenames = glob($ARGV[0]);
# my $tempfilename = "c:/tmp/mckoskey_temp.txt";

foreach my $infilename (@infilenames)
{
	print "\tprocessing $infilename...\n";

	my $infile   = IO::File->new($infilename, "<")   or croak "Unable to open \"" . $infilename   . "\": " . $OS_ERROR;
	my $tempfile = IO::File->new($tempfilename, ">") or croak "Unable to open \"" . $tempfilename . "\": " . $OS_ERROR;

	while(my $line = <$infile>)
	{
        chomp $line;

		print $tempfile $line;
		print $tempfile "\r";
		print $tempfile "\n";
	}
	
	close($tempfile);
	close($infile);

	copy($tempfilename, $infilename);
	unlink $tempfilename;
}

print "\n\tDone!\n\n";


sub Syntax
{
	print "\n\tsyntax: unix2dos <files>\n\n";
	exit(-1);
}


#
# end script
#
