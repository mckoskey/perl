#!/usr/bin/perl

use strict;
use warnings;

if($#ARGV < 0) { Syntax(); }

use strict;
use Carp;
use English;
use IO::File;
use File::Copy;

  my @infilenames = @ARGV;
  my $tempfilename = "/tmp/mckoskey_temp.txt";

# my @infilenames = glob($ARGV[0]);
# my $tempfilename = "c:/tmp/mckoskey_temp.txt";

foreach my $infilename (@infilenames)
{
    print "\tprocessing $infilename...\n";

    my $infile   = IO::File->new($infilename, "<")   or croak "Unable to open \"" . $infilename   . "\": " . $OS_ERROR;
    my $tempfile = IO::File->new($tempfilename, ">") or croak "Unable to open \"" . $tempfilename . "\": " . $OS_ERROR;

    while(my $line = <$infile>)
    {
        chomp $line;

        $line =~ s/\x91/`/g;       # left single quotation mark
        $line =~ s/\x92/'/g;       # right single quotation mark
        $line =~ s/\x93/``/g;      # left double quotation mark
        $line =~ s/\x94/''/g;      # right double quotation mark

        $line =~ s/\x95/\\item/g;  # bullet

        $line =~ s/\x96/--/g;      # en dash
        $line =~ s/\x97/--/g;      # em dash

        print $tempfile $line;
        print $tempfile "\n";
    }

    close($tempfile);
    close($infile);

    copy($tempfilename, $infilename);
    unlink $tempfilename;
}

sub Syntax
{
    print "\n\tsyntax: filter_tex <files>\n\n";
    exit(-1);
}
