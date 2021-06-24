#!/usr/bin/perl

use strict;
use warnings;
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);


use English;
use Utilities;

my $util = new Utilities();

my $dir = shift @ARGV;
   $dir =~ s/\///g;

my $zip_name = $util->get_file_timestamp() . "_" . $dir . ".zip";

my $command = "zip -r " . $zip_name . " " . $dir;

my $ret = system($command);

if($ret == 0)
{
    print "Created \"" . $zip_name . "\"...\n";
}
else
{
    print "Unable to create \"" . $zip_name . "\": " . $OS_ERROR . "\n";
}
