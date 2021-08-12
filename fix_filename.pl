#!/usr/bin/perl

use strict;
use warnings;

use Carp;
use Getopt::Long;

my $verbose = undef;

GetOptions
(
    'v=s' => \$verbose,
);

# my @filenames = glob($ARGV[0]);
  my @filenames = @ARGV;

foreach my $filename (@filenames)
{
    chomp $filename;

    my $newfilename = $filename;

    $filename =~ s/\(/\\\(/g;
    $filename =~ s/\)/\\\)/g;
    $filename =~ s/'/\\'/g;
    $filename =~ s/ /\\ /g;

    $newfilename =~ s/ /\_/g;
    $newfilename =~ s/\(/\_/g;
    $newfilename =~ s/\)//g;
    $newfilename =~ s/'//g;
    $newfilename = lc $newfilename;

    next if $filename eq $newfilename;

    if($verbose)
    {
        print "Changing \"" . $filename . "\" to \"" . $newfilename . "\"...\n";;
    }

    my $command = "mv " . $filename . " " . $newfilename;

    croak "Unable to rename \"" . $filename . "\" to \"" . $newfilename . "\", exiting." unless system($command) == 0;
}
