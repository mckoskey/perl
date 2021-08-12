#!/usr/bin/perl
#
# Name: split_file.pl
# Date: 9 June, 2011
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: split_file.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Split a file into multiple files.  



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
        <td>June 9, 2011</td>
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
use Getopt::Std;
use File::Basename;
use vars qw($opt_l);
getopts('l:');

my $lines = 10;
my @extensions = qw(.txt);

if(defined($opt_l) && length($opt_l) > 0) { $lines = $opt_l; }

if($#ARGV < 0) { syntax(); exit 0; }

my $infilename = shift @ARGV;
my $line_count = 1;
my $file_count = 1;

my ($name, $path, $extension) = fileparse($infilename, @extensions);
my $outfilename = $path . $name . "_" . $file_count . $extension;

my $infile  = IO::File->new($infilename, '<')  or croak "Unable to open \"" .  $infilename  . "\": " . $OS_ERROR;
my $outfile = IO::File->new($outfilename, '>') or croak "Unable to write \"" . $outfilename . "\": " . $OS_ERROR;

while (my $line = <$infile>)
{
    chomp($line);

    print $outfile ($line . "\n");

    if ($line_count > 0 && $line_count % $lines == 0)
    {
        close $outfile;

        $file_count++;

        $outfilename = $path . $name . "_" . $file_count . $extension;

        $outfile = IO::File->new($outfilename, '>') or croak "Unable to write \"" . $outfilename . "\": " . $OS_ERROR;
    }

    $line_count++;
}

close $infile;


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub syntax
{
    print "\n";
    print "    ";
    print "syntax: split_file [-l] <filename>\n";
    print "\n";
    print "    ";
    print "Splits the file into pieces of \"l\" lines each (default 10)\n";
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
