#!/usr/bin/perl
#
# Name: showinc.pl
# Date: 18 April, 2006
# Author: David McKoskey


use strict;
use warnings;

print "\n";
print "Here's the Perl \"\@INC\" path:\n";
print "\n";

foreach my $path (@INC)
{
    print "    ";
    print "path: \"" . $path . "\"\n";;
    print "\n";
}


#
# end script
#
