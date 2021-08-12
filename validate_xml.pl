#!/usr/bin/perl
#
# Name: validate_xml.pl
# Date: 
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: validate_xml.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Validate that a file is correct (valid) XML.  



=head2 Revision History

=begin html

<table border="1" style="border-collapse : collapse" cellpadding="10">
    <tr>
        <th bgcolor="tan">Name</th>
        <th bgcolor="tan">Date</th>
        <th bgcolor="tan">Description</th>
    </tr>
    <tr>
        <td>David McKoskey</td>
        <td>September 24, 2010</td>
        <td>Initial Revision</td>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td></td>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td></td>
    </tr>
</table>

=end html

=head2 Functions

=cut



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

my @extensions = qw(.xml);

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
}
else
{
    syntax();
    exit -1;
}


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub syntax
{
    print "\n";
    print "    ";
    print "syntax: perl validate_xml.pl -f <filename>\n";
    print "\n";
    print "    ";
    print "             or\n";
    print "\n";
    print "    ";
    print "        perl validate_xml.pl -d <directory>\n";
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


=pod

=head4 start_handler ()

Handle XML start tag.

=cut
sub start_handler
{
    my $parser = shift;
    my $current = shift;
}


=pod

=head4 end_handler ()

Handle XML end tag.

=cut
sub end_handler
{
    my $parser = shift;
    my $current = shift;
}


=pod

=head4 char_handler ()

Handle XML text.

=cut
sub char_handler
{
    my $parser = shift;
    my $data   = shift;
}


=pod

=head4 default_handler ()

Handle all other XML elements.

=cut
sub default_handler
{
    my $parser = shift;
    my $data   = shift;
}


=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
