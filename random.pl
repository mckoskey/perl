#!/usr/bin/perl
#
# Name: random.pl
# Date: 9 June, 2011
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: random.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Generate a random number.  



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
        <td>June 9, 1998</td>
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


if($#ARGV < 0) { Syntax(); exit 0; }

use strict;
use warnings;
use vars qw($opt_s $opt_e);
use Getopt::Std;
getopts('s:e:');

my ($start, $end);
my %used;
my @results;

my $number = shift @ARGV;

if($opt_s) { $start = $opt_s; } else { $start = 0; }
if($opt_e) { $end   = $opt_e; } else { $end   = $number; }

my $range = abs($start - $end);

print "Random numbers from " . $start . " to " . $end . "\n";

while ($#results < $number - 1 && $#results < $range - 1)
{
	my $random = abs(int(rand() * $range));

	if(!$used{$random})
	{
		$used{$random}++;
		push(@results, $random);
		print "\t" . $random . "\t" . dec2bin($random) . "\n";
	}
}


=pod

=head4 dec2bin()

Convert decimal numbers to binary.  Pilfered directly from The Perl Cookbook (Christiansen & Torkington, 1998).  

=cut
sub dec2bin
{
	my $str = unpack("B32", pack("N", shift));
	$str =~ s/^0+(?=\d)//;
	return $str;
}


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub Syntax
{
	print "\n";
	print "    ";
	print "syntax: random [-s <start>] [-e <end>] <number>";
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
