#!/usr/bin/perl
#
# name: findinc
# date: 19 March, 2007
# author: David McKoskey
# purpose: show the paths in @INC

use strict;
use warnings;
use lib qw(c:/bin/perl /home/mckoskey/bin/perl);

print "\n";
print "Here's the Perl \"\@INC\" path:\n";
print "\n";

foreach my $path (@INC)
{
	print "\t";
    print "path: \"" . $path . "\"\n";;
	print "\n";
}

#
# end script
#
