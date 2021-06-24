#!/usr/bin/perl
#
# Name: pathfind.pl
# Date: 9 June 2011
# Author: David McKoskey


use strict;
use warnings;

if($#ARGV < 0) { syntax(); }

my @dirs;
my $file = $ARGV[0];

if($ENV{PATH} =~ /\//) # unix
{
	@dirs = split /:/, $ENV{PATH};

	foreach my $dir (@dirs)
	{
		my $path = $dir . "\/" . $file;

		print "Checking \"" . $dir . "\"\n";

		if(-e $path)
		{
			print "\t\"" . $file . "\" found in " . $dir . "\n";
		}

		print "\n";
	}
}
else # win32
{
	@dirs = split /;/, $ENV{PATH};

	foreach my $dir (@dirs)
	{
		my $path = $dir . "\\" . $file;

		print "Checking \"" . $dir . "\"\n";

		if(-e $path)
		{
			print "\t\"" . $file . "\" found in " . $dir . "\n";
		}

		print "\n";
	}
}

=cut
sub syntax
{
	print"\n\tSyntax: pathfind <filename>\n\n";
	exit(-1);
}


#
# end script
#
