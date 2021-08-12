#!/usr/bin/perl
#
# Name: getlines.pl
# Date: 7 August, 1998
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: getlines.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Gets specified lines from a file



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
        <td>August 7, 1998</td>
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

# copy input variables
my $start = $ARGV[0];
my $end = $ARGV[1];
my $filename = $ARGV[2];

if ( $#ARGV != 2 ) { syntax (); }     # at least three parameters
if ( $start =~ /\D/ ) { syntax (); }  # start line must be numeric
if ( $end =~ /\D/ ) { syntax (); }    # end line must be numeric

my $file = IO::File->new($filename, "<") or croak  "Unable to open " . $filename . ": " . $OS_ERROR;

my @file_array = <$file>;      # load the file into an array  

# print the desired lines
for (my $i = $start - 1; $i <= $end - 1; $i++) { print "$file_array[$i]"; }

close($file);  # close file


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub syntax
{
	printf ("\n\t getlines: get lines from a file\n");
	printf ("\n\t Syntax: getlines \<start\> \<end\> \<file\>\n");
	printf ("\t           start = starting line in \<file\>\n");
	printf ("\t             end = ending line in \<file\>\n");
	printf ("\t            note: first line is 1, not 0\n\n");
	exit(1);
}


=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
