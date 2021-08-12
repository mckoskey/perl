#!/usr/bin/perl

use strict;
use warnings;
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use IO::File;
use Utilities;

my $util = new Utilities();

my $infilename   = shift @ARGV;
my $tempfilename = $util->get_file_timestamp() . "_" . getppid() . ".tmp";
my %patterns = (
    '\\\u160\\?' => ' ',
    '\\\line' => '\\par',
);

my $infile   = IO::File->new($infilename,   '<') or croak "Unable to read \""  . $infilename   . "\":" . $OS_ERROR;
my $tempfile = IO::File->new($tempfilename, '>') or croak "Unable to write \"" . $tempfilename . "\":" . $OS_ERROR;

while (my $line = <$infile>)
{
    chomp $line;

    foreach my $find (keys %patterns)
    {
        my $replace = $patterns{$find};

        $line =~ s/$find/$replace/g;
    }

    print $tempfile $line;
    print $tempfile "\n";
}

close $infile;
close $tempfile;

# my $command = "del /y " . $infilename;
  my $command = "rm "     . $infilename;
  system($command);

# $command = "move /y " . $tempfilename . " " $infilename;
  $command = "mv "      . $tempfilename . " " . $infilename;
  system($command);
