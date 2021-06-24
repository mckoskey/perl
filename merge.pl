#!/usr/bin/perl
#
# Name: merge.pl
# Date: 8 June, 2011
# Author: David McKoskey




use strict;
use warnings;

use Getopt::Long;
use File::Copy;
use File::Basename;

my $verbose = undef;
my $target_dir = undef;

my @extensions = qw(.txt .xml .java .c .cpp);

GetOptions
(
    'v' => \$verbose,
    't=s' => \$target_dir,
);

unless(defined($target_dir))
{
    syntax();
    exit -1;
}

unless(-d $target_dir)
{
    print "Target directory \"" . $target_dir . "\" does not exist.\n";
}

if(defined($verbose))
{
    print "Target Directory: \"" . $target_dir . "\"\n";
    print "Verbose mode ON\n";
    print "\n";
}



my @sourcefilenames = glob($ARGV[0]);

foreach my $sourcefilename (@sourcefilenames)
{
    my ($title, $path, $extension) = fileparse($sourcefilename, @extensions);

    my $targetfilename = $target_dir . "\\" . $title . $extension;

    if(defined($verbose))
    {
        print "Verifying a merge for \"" . $sourcefilename . "\" to \"" . $targetfilename . "\"...\n";
    }

    if(-e $targetfilename)
    {
        if(defined($verbose))
        {
            print "\"" . $targetfilename . "\" already exists, skipping.\n";
        }
    }
    else
    {
        if(defined($verbose))
        {
            print "\"" . $targetfilename . "\" does not exist, proceeding with copy.\n";
        }

        my $ret = copy($sourcefilename, $targetfilename);

        if(defined($verbose))
        {
            if($ret > 0)
            {
                print "Copying \"" . $sourcefilename . "\" to \"" . $targetfilename . "\" succeeded.\n";
            }
            else
            {
                print "ERROR: copying \"" . $sourcefilename . "\" to \"" . $targetfilename . "\" failed.\n";
            }

            print "\n";
        }
    }
}


sub syntax
{
    print "\n";
    print "    ";
    print "syntax: merge [-v] -t <target> <source>";
    print "\n";
}

#
# end script
#
