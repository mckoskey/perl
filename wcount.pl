#!/usr/bin/perl
#
# Name: wcount.pl
# Date: 9 June, 2011
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: wcount.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Count the number of words and lines in a file.  



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


if($#ARGV < 0) { syntax(); exit 0; }

use strict;
use warnings;

use Carp;
use English;
use IO::File;

my @infiles = glob($ARGV[0]);
my ($totalcharcount, $totallinecount, $totalwordcount);

foreach my $infile (@infiles)
{
	my $linecount = 0;
	my $wordcount = 0;
	my $charcount = 0;

	my $file = IO::File->new($infile, "<") or croak "Unable to open file \"" . $infile . "\": " . $OS_ERROR;

	while(my $line = <$file>)
	{
		chomp($line);
		my @words = split /\s+/, $line;	

		foreach my $word (@words)
		{
			$charcount += length($word);
			$totalcharcount += length($word);

			$wordcount++;
			$totalwordcount++;
		}

		$linecount++;
		$totallinecount++;
	}

	close ($file);

	print " $infile:\n\tchars = $charcount\n\tlines = $linecount\n\twords = $wordcount\n\n";
}

print " Total:\n\tchars = $totalcharcount\n\tlines = $totallinecount\n\twords = $totalwordcount\n\n";


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub syntax
{
	print "\n";
	print "    ";
	print "syntax: wcount <filename(s)>\n";
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
