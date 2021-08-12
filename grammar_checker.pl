#/usr/bin/perl

use strict;
use warnings;

use Carp;
use English;
use IO::File;


my $infilename = shift @ARGV;

my $infile = IO::File->new($infilename, '<') or croak "Unable to open \"" . $infilename . "\":" . $OS_ERROR;

while (my $line = <$infile>)
{
    chomp $line;

    # Permutations of "the the"
    print "        the the\n" if ($line =~ /\s+the\s+the\s+/i || $line =~ /^the\s+the\s+/i || $line =~ /\s+the\s+the$/i || $line =~ /^the\s+the$/i);
}

close $infile;
