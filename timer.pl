#!/usr/bin/perl
#
# Name: timer.pl
# Date: 9 June, 2011
# Author: David McKoskey


if($#ARGV < 0) { Syntax(); exit 0; }

use strict;
use warnings;

my $command;

while (@ARGV)
{
	$command = $command . shift @ARGV;
	if($#ARGV >= 0) { $command = $command . " "; }
}

print " Executing: \"" . $command . "\"\n";
print "     Start: ";
print scalar localtime; # UNIX-style time
print "\n";
system($command);
print "       End: ";
print scalar localtime; # UNIX-style time
print "\n";


sub Syntax
{
	print "\n";
	print "    ";
	print "timer <command>";
	print "\n";
}

#
# end script
#
