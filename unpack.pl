#!/usr/bin/perl
#
# Name: unpack.pl
# Date: 23 June, 2011
# Author: David McKoskey

use strict;
use warnings;
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use IO::File;
use Utilities;
use Getopt::Long;

my $uuencode = undef;
my $encrypt  = undef;

GetOptions
(
    'e' => \$encrypt,
    'u' => \$uuencode,
);

if($#ARGV < 0)
{
    Syntax();

    exit -1;
}

my $util = new Utilities();

my @filenames = @ARGV;

foreach my $file_name (@filenames)
{
    if(! $util->test_var($encrypt) && ! $util->test_var($uuencode))
    {
        my $command = "unzip -qq " . $file_name;

        my $ret = system($command);
    }

    if($util->test_var($uuencode) && ! $util->test_var($encrypt))
    {
        my $command = "unzip -qq " . $file_name;

        my $ret = system($command);

        if($ret == 0)
        {
            my $tmpzip1 = "tmp1.zip";
            my $tmptxt1 = "tmp1.txt";

            my $tmpzip = IO::File->new($tmpzip1, '>') or croak "Unable to create \""   . $tmpzip1 . "\": " . $OS_ERROR;
            my $tmpuu  = IO::File->new($tmptxt1, '<') or croak "Unable to open \"" . $tmptxt1 . "\": " . $OS_ERROR;

            binmode $tmpzip;
            my $line;

            while(my $line = <$tmpuu>)
            {
                chomp $line;

                print $tmpzip unpack("u", $line);
            }

            close $tmpzip;
            close $tmpuu;

            $command = "unzip -qq " . $tmpzip1;

            my $ret = system($command);

            if($ret != 0)
            {
                print "Unable to unpack \"" . $file_name . "\": " . $OS_ERROR . "\n";
            }

            unlink $tmpzip1;
            unlink $tmptxt1;
        }
        else
        {
            print "Unable to unpack \"" . $file_name . "\": " . $OS_ERROR . "\n";
        }
    }

    if(! $util->test_var($uuencode) && $util->test_var($encrypt))
    {
        my $tmpzip1 = "tmp1.zip";

        my  $command = "gpg -o " . $tmpzip1 . " -d " . $file_name;

        my $ret = system($command);

        if($ret == 0)
        {
            $command = "unzip -qq " . $tmpzip1;

            $ret = system($command);
        }

        unlink $tmpzip1 if -f $tmpzip1;

        next;
    }

    if($util->test_var($uuencode) && $util->test_var($encrypt))
    {
        my $tmpzip2 = "tmp2.zip";

        my  $command = "gpg -o " . $tmpzip2 . " -d " . $file_name;

        my $ret = system($command);

        if($ret == 0)
        {
            $command = "unzip -qq " . $tmpzip2;

            my $tmpzip1 = "tmp1.zip";
            my $tmptxt1 = "tmp1.txt";

            my $tmpzip = IO::File->new($tmpzip1, '>') or croak "Unable to create \""   . $tmpzip1 . "\": " . $OS_ERROR;
            my $tmpuu  = IO::File->new($tmptxt1, '<') or croak "Unable to open \"" . $tmptxt1 . "\": " . $OS_ERROR;

            binmode $tmpzip;
            my $line;

            while(my $line = <$tmpuu>)
            {
                chomp $line;

                print $tmpzip unpack("u", $line);
            }

            close $tmpzip;
            close $tmpuu;

            $command = "unzip -qq " . $tmpzip1;

            my $ret = system($command);

            if($ret != 0)
            {
                print "Unable to unpack \"" . $file_name . "\": " . $OS_ERROR . "\n";
            }

            unlink $tmpzip2 if -f $tmpzip2;
            unlink $tmpzip1 if -f $tmpzip1;
            unlink $tmptxt1 if -f $tmptxt1;
        }
        else
        {
            print "Unable to unpack \"" . $file_name . "\": " . $OS_ERROR . "\n";
        }
    }
}


sub Syntax
{
    print "\n";
    print "    syntax: unpack [-eu] <filename>\n";
    print "\n";
    print "   options:  -u uuencoded ZIP file contents";
    print "             -e encrypted file";
    print "\n";
}

#
# end script
#
