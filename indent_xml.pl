#!/usr/bin/perl
#
# Name: indent_xml.pl
# Date: October 16, 2009
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: indent_xml.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Indent XML tags and output text.



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
        <td>August 26, 1998</td>
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
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use IO::File;
use Utilities;
use XML::Parser;
use Getopt::Std;
use File::Basename;
use vars qw($opt_l $opt_r $opt_s);
getopts('l:rs');

my $replace = 0;
my $util = new Utilities();

# my %ignore_tags = ( );
  my %ignore_tags = ( 'a' => 1 );

  my $copy = "cp ";
# my $copy = "copy /y ";

  my $delete = "rm ";
# my $delete = "del /q ";

if($opt_r) { $replace = 1; }

my $parser = new XML::Parser(Style => 'Debug');

   $parser->setHandlers(
                        Start => \&start_handler,
                          End => \&end_handler,
                         Char => \&char_handler,
                      Default => \&default_handler
                       );

my @extensions = qw(.xml .html .htm);
my $outfile;
my $current_infilename;
my $indent = 0;
my $infiles_ref = undef;

if(defined($opt_l) && length($opt_l) > 0)
    { $infiles_ref = $util->get_infiles_from_list($opt_l); }
else
    { $infiles_ref = $util->get_infiles_from_argv(\@ARGV); }

# my $indent_char = " ";
  my $indent_char = "    ";
# my $indent_char = "\t";

if(scalar @{$infiles_ref} == 0)
{
    syntax();
    exit 0;
}

foreach my $infilename (@{$infiles_ref})
{
    # print "Processing \"" . $infilename . "\"\n";

    $current_infilename = $infilename;

    my($name, $path, $extension) = fileparse($infilename, @extensions);

    my $outfilename = $path . $name . "_indent" . $extension;

    $outfile = IO::File->new($outfilename, ">") or croak "Unable to open output file \"" . $outfilename . "\": " . $OS_ERROR;

    $parser->parsefile($infilename);

    close($outfile);

    if($replace == 1)
    {
        my $command = $copy . $outfilename . " " . $infilename;
        # print $command . "\n";
        system($command) == 0 or croak "Unable to run \"" . $command . "\"\n";

        $command = $delete . $outfilename;
        # print $command . "\n";
        system($command) == 0 or croak "Unable to run \"" . $command . "\"\n";
    }
}


=pod

=head4 start_handler()

Handle XML start tags.

=cut
sub start_handler
{
    my ($parser, $current, %attributes) = @_;

    return if($ignore_tags{$current});

    for(my $i = 0; $i < $indent; $i++) { print $outfile $indent_char; }

    $indent++;

    print $outfile "<";
    print $outfile $current;

    foreach my $attribute (sort keys %attributes)
    {
        print $outfile " ";
        print $outfile $attribute;
        print $outfile "=\"";
        print $outfile $attributes{$attribute};
        print $outfile "\"";
    }

    print $outfile ">";

    if($opt_s && lc($current) eq "title") { print $outfile $current_infilename; }

    print $outfile "\n";
}


=pod

=head4 end_handler()

Handle XML end tags

=cut
sub end_handler
{
    my $parser = shift;
    my $current = shift;

    return if($ignore_tags{$current});

    $indent--;

    for(my $i = 0; $i < $indent; $i++) { print $outfile $indent_char; }

    print $outfile "</" . $current . ">";
    print $outfile "\n";
}


=pod

=head4 char_handler()

Handle XML text

=cut
sub char_handler
{
    my $parser = shift;
    my $data   = shift;

    chomp($data);
    $data = $util->trim($data);

    return unless defined($data);
    return if length($data) == 0;

    if($data =~ /&/)
    {
        if($data eq '&')
            { $data = "&amp;"; }
        else
            { $data =~ s/&/&amp;/g; }
    }

    for(my $i = 0; $i < $indent; $i++) { print $outfile $indent_char; }

    print $outfile $data;
    print $outfile "\n";
}


=pod

=head4 default_handler()

Handle anything the other handlers don't.

=cut
sub default_handler
{
    my $parser = shift;
    my $data   = shift;

    chomp($data);
    $data = $util->trim($data);

    return unless defined($data);
    return if length($data) == 0;

    if($data =~ /&/)
    {
        if($data eq '&')
            { $data = "&amp;"; }
        else
            { $data =~ s/&/&amp;/g; }
    }

    for(my $i = 0; $i < $indent; $i++) { print $outfile $indent_char; }

    print $outfile $data;
    print $outfile "\n";
}


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub syntax
{
    print "\n";
    print "    ";
    print "Syntax: indent_xml <filenames>";
    print "\n";
    print "\n";
    print "        -l file list name";
    print "\n";
    print "        -r replace";
    print "\n";
    print "\n";
}


=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
