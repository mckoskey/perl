#!/usr/bin/perl
#
# Name: tag_count.pl
# Date: 21 June, 2011
# Author: David McKoskey


use strict;
use warnings;

use Carp;
use English;
use IO::File;
use XML::Parser;
use Getopt::Long;
use File::Basename;
use File::Find;

my $directory_name = undef;
my $filename = undef;

my $delimiter = "    ";
my $max_tag_size = 0;
my @extensions = qw(.html .xhtml .xls .xlt .xml);
my %tag_counts;

GetOptions
(
    'd=s' => \$directory_name,
    'f=s' => \$filename
);

my $parser = new XML::Parser(Style => 'Debug');

   $parser->setHandlers(
                        Start => \&start_handler,
                          End => \&end_handler,
                         Char => \&char_handler,
                      Default => \&default_handler
                       );

if(test_var($directory_name) || test_var($filename))
{
    if(test_var($directory_name))
    {
        unless(-d $directory_name)
        {
            print "ERROR: \"" . $directory_name . "\" is not a valid directory.  Halting.\n";
            exit -1;
        }

        find(\&find_files, $directory_name);
    }

    if (test_var($filename))
    {
        unless(-f $filename)
        {
            print "ERROR: \"" . $filename . "\" is not a valid file name.  Halting.\n";
            exit -1;
        }

        process_files($filename);
    }

    foreach my $tag (sort keys %tag_counts)
    {
        print $tag;
        print $delimiter;
        
        for(my $i = 0; $i < $max_tag_size - length($tag); $i++) { print " "; }

        print $tag_counts{$tag};
        print "\n";
    }
}
else
{
    syntax();
    exit -1;
}


sub syntax
{
    print "\n";
    print "    ";
    print "syntax: perl tag_count.pl -f <filename>\n";
    print "\n";
    print "    ";
    print "             or\n";
    print "\n";
    print "    ";
    print "        perl tag_count.pl -d <directory>\n";
    print "\n";
}

sub find_files
{
    my $filename = $File::Find::name;

    if(! -d $filename && test_var($filename) && has_pattern($filename)){ process_files($filename); }
}
sub has_pattern
{
    my $filename = shift;

    my($name, $path, $extension) = fileparse($filename, @extensions);

    # look for .lock extension
    if(test_var($extension))
        { return 1; }
    else
        { return 0; }
}

sub test_var
{
    my $var  = shift;

    if(defined($var) && length($var) > 0)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

sub process_files
{
    my $filename = shift;

    # print "Processing \"" . $filename . "\"...\n";

    eval
    {
        $parser->parsefile($filename);
    }
    or do
    {
        print "Error in\'" . $filename . "\":" . $@;
    };
}


sub start_handler
{
    my ($parser, $current_tag, %attributes) = @_;

    $tag_counts{$current_tag}++;

    if(defined($current_tag) && length($current_tag) > $max_tag_size)
    {
        $max_tag_size = length($current_tag);
    }
}


sub end_handler
{
    my $parser = shift;
    my $current = shift;
}


sub char_handler
{
    my $parser = shift;
    my $data   = shift;
}


sub default_handler
{
    my $parser = shift;
    my $data   = shift;
}

#
# end script
#
