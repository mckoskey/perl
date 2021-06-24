#!/usr/bin/perl
#
# Name: pack.pl
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

my $uuencode   = undef;
my $encrypt    = undef;
my $usedirname = undef;

GetOptions
(
    'u' => \$uuencode,
    'e' => \$encrypt,
    'd' => \$usedirname,
);

if($#ARGV < 0)
{
    syntax();

    exit -1;
}
my $util = new Utilities();

my $dir_name = shift @ARGV;
my $zip_name = undef;

my @extensions = qw(docx xlsx pptx);

my $extensions_size = scalar @extensions;
my $random_number_2 = int(rand($extensions_size));

$dir_name =~ s/\///g;

if($usedirname)
{
    $zip_name = $util->get_file_timestamp() . "_" . $dir_name . "." . $extensions[$random_number_2];
}
else
{
    my @names = qw(advanced_java advanced_sql basic_java basic_sql
                   oracle_tuning oracle_partition_tables sql_tuning_guide
                   business_communications daily_planning_tips personal_safety
                   communications_skills_I communications_skills_II 
    );

    my $names_size = scalar @names;
    my $random_number_1 = int(rand($names_size));

    $zip_name = $util->get_file_timestamp() . "_" . $names[$random_number_1] . "." . $extensions[$random_number_2];
}

my $pgp_id = "david\@mckoskey.com";

# skip the uuencode process
if(! $util->test_var($uuencode) && ! $util->test_var($encrypt))
{
    my $command = "zip -q -r " . $zip_name . " " . $dir_name;

    my $ret = system($command);

    if($ret == 0)
    {
        print "Created \"" . $zip_name . "\"...\n";
    }
    else
    {
        print "Unable to create \"" . $zip_name . "\": " . $OS_ERROR . "\n";
    }

    exit 0;
}

if($util->test_var($uuencode) && ! $util->test_var($encrypt))
{
    my $tmpzip1 = "tmp1.zip";
    my $tmpzip2 = "tmp2.zip";
    my $tmptxt1 = "tmp1.txt";

    my $command = "zip -q -r " . $tmpzip1 . " " . $dir_name;

    my $ret = system($command);

    if($ret == 0)
    {
        my $tmpzip = IO::File->new($tmpzip1, '<') or croak "Unable to open \"" . $tmpzip1 . "\": " . $OS_ERROR;
        my $tmpuu  = IO::File->new($tmptxt1, '>') or croak "Unable to create \"" . $tmptxt1 . "\": " . $OS_ERROR;

        my $line;

        while(read($tmpzip, $line, 45))
        {
            print $tmpuu pack("u", $line);
        }

        close $tmpzip;
        close $tmpuu;

        $command = "zip -q " . $tmpzip2 . " " . $tmptxt1;

        my $ret = system($command);

        if($ret == 0)
        {
            rename $tmpzip2, $zip_name;

            print "Created \"" . $zip_name . "\"...\n";
        }
        else
        {
            print "Unable to create \"" . $zip_name . "\": " . $OS_ERROR . "\n";
        }

        unlink $tmpzip1;
        unlink $tmptxt1;
    }
    else
    {
        print "Unable to create \"" . $zip_name . "\": " . $OS_ERROR . "\n";
    }
}

if(! $util->test_var($uuencode) && $util->test_var($encrypt))
{
    my $tmpzip1 = "tmp1.zip";

    my $command = "zip -q -r " . $tmpzip1 . " " . $dir_name;

    my $ret = system($command);

    if($ret == 0)
    {
        $command = "gpg -r " . $pgp_id . " -o " . $zip_name . " -q -s -e " . $tmpzip1;

        $ret = system($command);

        if($ret == 0)
        {
            unlink $tmpzip1;

            print "Created \"" . $zip_name . "\"...\n";
        }
        else
        {
            print "Unable to create \"" . $zip_name . "\": " . $OS_ERROR . "\n";
        }
    }
    else
    {
        print "Unable to create \"" . $zip_name . "\": " . $OS_ERROR . "\n";
    }

    exit 0;
}

if($util->test_var($uuencode) && $util->test_var($encrypt))
{
    my $tmpzip1 = "tmp1.zip";
    my $tmpzip2 = "tmp2.zip";
    my $tmptxt1 = "tmp1.txt";

    my $command = "zip -q -r " . $tmpzip1 . " " . $dir_name;

    my $ret = system($command);

    if($ret == 0)
    {
        my $tmpzip = IO::File->new($tmpzip1, '<') or croak "Unable to open \"" . $tmpzip1 . "\": " . $OS_ERROR;
        my $tmpuu  = IO::File->new($tmptxt1, '>') or croak "Unable to create \"" . $tmptxt1 . "\": " . $OS_ERROR;

        my $line;

        while(read($tmpzip, $line, 45))
        {
            print $tmpuu pack("u", $line);
        }

        close $tmpzip;
        close $tmpuu;

        $command = "zip -q " . $tmpzip2 . " " . $tmptxt1;

        my $ret = system($command);

        if($ret == 0)
        {
            $command = "gpg -r " . $pgp_id . " -o " . $zip_name . " -q -s -e " . $tmpzip2;

            $ret = system($command);

            if($ret == 0)
            {
                unlink $tmpzip1;

                print "Created \"" . $zip_name . "\"...\n";
            }
            else
            {
                print "Unable to create \"" . $zip_name . "\": " . $OS_ERROR . "\n";
            }
        }
        else
        {
            print "Unable to create \"" . $zip_name . "\": " . $OS_ERROR . "\n";
        }

        unlink $tmpzip1;
        unlink $tmptxt1;
    }
    else
    {
        print "Unable to create \"" . $zip_name . "\": " . $OS_ERROR . "\n";
    }
}

sub syntax
{
    print "\n";
    print "    syntax: pack [\-ce] \<dir\>";
    print "\n";
    print "    options:  \-e PGP encrypt zip contents\n";
    print "              \-u uuencode zip contents\n";
    print "\n";
}

#
# end script
#
