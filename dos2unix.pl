#!/usr/bin/perl
#
# Name: dos2unix
# Date: 18 April, 2005
# Author: David McKoskey

use strict;
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use IO::File;
use Utilities;
use File::Copy;

use Data::Dumper;

my @infilenames = @ARGV;
my $tempfilename = "/tmp/mckoskey_temp.txt";
my $util = new Utilities();

if($#ARGV < 0)
{
    if($OSNAME =~ /linux/)
    {
        my $command = "file * | grep -i text | awk -F: '{ print \$1 }'";
        my @tempfilenames = `$command`;

        foreach my $tempfilename (@tempfilenames)
        {
            $tempfilename = $util->trim($tempfilename);
            push(@infilenames, $tempfilename);
        }
    }
    else
    {
        Syntax();
    }
}

# my @infilenames = glob($ARGV[0]);
# my $tempfilename = "c:/tmp/mckoskey_temp.txt";

foreach my $infilename (@infilenames)
{
    # print "    Processing \"" . $infilename . "\"...\n";

    my $infile   = IO::File->new($infilename, "<")   or croak "Unable to open \"" . $infilename   . "\": " . $OS_ERROR;
    my $tempfile = IO::File->new($tempfilename, ">") or croak "Unable to open \"" . $tempfilename . "\": " . $OS_ERROR;

    while(my $line = <$infile>)
    {
        chomp $line;

        $line =~ s/\r//g;

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
    print "\n\tsyntax: dos2unix <files>\n\n";
    exit(-1);
}

#
# end script
#
