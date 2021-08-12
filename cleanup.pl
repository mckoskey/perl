#!/usr/bin/perl

use strict;
use warnings;
use File::Find;
use File::Path;
use File::Basename;

my $start_dir = shift @ARGV;
my @extensions;
my $file_count = 0;
my $win32 = 1;

if($#ARGV < 0)
{
    syntax();
    exit(-1);
}

print "Starting in directory \"" . $start_dir . "\".\n";

foreach my $extension (@ARGV)
{
    if($extension !~ /\./) { $extension = "." . $extension; }

    print "Adding extension \"" . $extension . "\"...\n";

    push(@extensions, $extension);
}

print "\n";

find(\&findFiles, $start_dir);

   if ($file_count == 0) { print "No files deleted.\n"; }
elsif ($file_count == 1) { print "1 file deleted.\n"; }
else { print $file_count . " files deleted.\n"; }

print "Done!\n";

sub findFiles
{
    my $filename = $File::Find::name;
    my($name, $path, $extension) = fileparse($filename, @extensions);

    # If we've found a file of the
    # desired extension, delete it.
    if(length($extension) > 0)
    {
        my $ret = -1;
        my $command;

        if($win32)
        {
            $command = "del /q " . ($name . $extension);
        }
        else
        {
            $command = "rm -f " . ($name . $extension);
        }

        # print "Command: \"" . $command . "\"\n";

        print "Deleting \"" . $filename . "\"... ";
        $ret = system($command);

        if ($ret == 0)
        {
            print "DONE.\n";
            $file_count++;
        }
        else
        {
            print "ERROR.\n";
        }
    }
}

sub syntax
{
    print "\n";
    print "    Syntax: " . $0  . " <start dir> <ext1.> <ext2.> <ext3.> ... \n";
    print "\n";
}
