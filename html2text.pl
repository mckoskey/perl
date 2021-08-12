#!/usr/bin/perl
if($#ARGV < 0) { Syntax(); }

use strict;
use warnings;
use XML::Parser;

my $input_file_name = shift @ARGV;
my $space_padding = '    ';
my $list_character = '*';
my $heading_characters = '~=*=~';

my $parser = new XML::Parser(Style => 'Debug');

   $parser->setHandlers(Start => \&start_handler,
                          End => \&end_handler,
                         Char => \&char_handler);

   $parser->parsefile($input_file_name);

sub start_handler
{
    my $parser = shift;
    my $current = shift;

    # print "start current: \"" . $current . "\"\n\n";

    if($current eq 'h3')
    {
        print $heading_characters . ' ';
    }

    if($current eq 'li')
    {
        print $space_padding;
        print $list_character . ' ';
    }
}

sub end_handler
{
    my $parser = shift;
    my $current = shift;

    if($current eq 'h3')
    {
        print ' ' . $heading_characters;
    }

    if($current eq "li" || $current eq "ul")
    {
        print "\n";
    }

    if($current eq "h3" || $current eq "p")
    {
        print "\n";
        print "\n";
    }

    # print "end current: \"" . $current . "\"\n\n";
}

sub char_handler
{
   my $parser = shift;
   my $data   = shift;

   chomp($data);
   return if length($data) == 0;
   # print "data : \"" . $data . "\"\n\n";

   print $data;
}

1;

sub Syntax
{
    print "\n";
    print "\tSyntax: html2text <filename>\n";
    print "\n";
    exit -1;
}

#
# End script
#
