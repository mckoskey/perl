#!/usr/bin/perl
#
# Name: split_file.pl
# Date: 9 June, 2011
# Author: David McKoskey


use strict;
use warnings;

use Carp;
use English;
use IO::File;
use Getopt::Std;
use File::Basename;
use vars qw($opt_l);
getopts('l:');

my $lines = 10;
my @extensions = qw(.txt);

if(defined($opt_l) && length($opt_l) > 0) { $lines = $opt_l; }

if($#ARGV < 0) { syntax(); exit 0; }

my $infilename = shift @ARGV;
my $line_count = 1;
my $file_count = 1;

my ($name, $path, $extension) = fileparse($infilename, @extensions);
my $outfilename = $path . $name . "_" . $file_count . $extension;

my $infile  = IO::File->new($infilename, '<')  or croak "Unable to open \"" .  $infilename  . "\": " . $OS_ERROR;
my $outfile = IO::File->new($outfilename, '>') or croak "Unable to write \"" . $outfilename . "\": " . $OS_ERROR;

while (my $line = <$infile>)
{
    chomp($line);

    print $outfile ($line . "\n");

    if ($line_count > 0 && $line_count % $lines == 0)
    {
        close $outfile;

        $file_count++;

        $outfilename = $path . $name . "_" . $file_count . $extension;

        $outfile = IO::File->new($outfilename, '>') or croak "Unable to write \"" . $outfilename . "\": " . $OS_ERROR;
    }

    $line_count++;
}

close $infile;


sub syntax
{
    print "\n";
    print "    ";
    print "syntax: split_file [-l] <filename>\n";
    print "\n";
    print "    ";
    print "Splits the file into pieces of \"l\" lines each (default 10)\n";
    print "\n";
}


#
# end script
#
