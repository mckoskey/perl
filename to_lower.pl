#!/usr/bin/perl

# Name: to_lower.pl
# Date: 27 April, 2011
# Author: David McKoskey

if($#ARGV < 0) { Syntax(); }

use strict;
use warnings;
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Env;
use Utilities;

# my @infilenames = glob($ARGV[0]);
  my @infilenames = @ARGV;

my $util = new Utilities();
my $os = $ENV{'OS'};

foreach my $infilename (@infilenames)
{
    # next if -f lc($infilename);

    my $newfilename = $infilename;

    $newfilename = lc $newfilename;
    $newfilename =~ s/ /_/g;
    $newfilename =~ s/"//g;
    $newfilename =~ s/'//g;
    $newfilename =~ s/\(//g;
    $newfilename =~ s/\)//g;
    $newfilename =~ s/,//g;
    $newfilename =~ s/;//g;
    $newfilename =~ s/&/and/g;

    $infilename =~ s/'/\\'/g;
    $infilename =~ s/;/\\;/g;
    $infilename =~ s/\(/\\\(/g;
    $infilename =~ s/\)/\\\)/g;

    my $command;

    if($util->test_var($os) && (lc $os) =~ "windows") {
        if($infilename =~ / /) {
            $command = "ren \"" . $infilename . "\" " . $newfilename;
        } else {
            $command = "ren " . $infilename . " " . $newfilename;
        }
    } else {
        $infilename =~ s/ /\\ /g;

        $command = "mv " . $infilename . " " . $newfilename;
    }

    print $command . "\n";

    system($command);
}

sub Syntax
{
	print "\n\tsyntax: to_lower <files>\n\n";
	exit(-1);
}

#
# end script
#
