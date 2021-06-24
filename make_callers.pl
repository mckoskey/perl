#!/usr/bin/perl
#
# Name: make_callers.pl
# Date: 8 June, 2011
# Author: David McKoskey


use strict;
use warnings;

use Carp;
use English;
use IO::File;
use File::Basename;

# my @infilenames = @ARGV;
  my @infilenames = glob($ARGV[0]);

my @extensions = qw(.pl);
my $win32path = "c:\\env\\bin";

foreach my $infilename (@infilenames)
{
    next if $infilename =~ /make_callers/;

    my($name, $path, $extension) = fileparse($infilename, @extensions);

    my $win32outfilename = "..\\" . $name . ".bat";

    print "Creating \"" . $win32outfilename . "\"\n";
    
    my $win32outfile = IO::File->new($win32outfilename, ">") or croak "Unable to create \"" . $win32outfilename . "\": " . $OS_ERROR;

    print $win32outfile "\@echo off\n";
    print $win32outfile "\n";
    print $win32outfile "perl " . $win32path . "\\perl\\" . $infilename . " %1 %2 %3 %4 %5 %6 %7 %8 %9\n";

    close $win32outfile;
}

#
# end script
#
