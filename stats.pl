#!/usr/bin/perl
#
# Name: stats.pl
# Date: 28 April, 1998
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: stats.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Compute mean and standard deviation for an input sample.



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
        <td>April 28, 1998</td>
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

# check command line
if ( $#ARGV <= 0 ) { syntax (); exit 0; }

# compute average:
my $n = $#ARGV + 1;   

my $sumx = 0;

for (my $i = 0; $i <= $n; $i++)
{
    next unless defined($ARGV[$i]);

    $sumx += $ARGV[$i];
}

my $mu = $sumx / $n;

# compute standard dev.:
my $sumsq = 0;

for ( my $j = 0; $j <= $n; $j++ )
{
    next unless defined($ARGV[$j]);

    $sumsq += ( ( $ARGV[$j] - $mu ) ** 2 );
}

my $sigma = sqrt ( $sumsq / $n );

# report results
printf("\n\t   Mu = $mu\n");
printf("\tSigma = $sigma\n\n");


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub syntax
{
	printf ("\n\tSyntax: stats <numbers>\n");
	printf ("\t(numbers = data to be analyzed)\n\n");
}


=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
