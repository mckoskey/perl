#!/usr/bin/perl
#
# Name: sortall.pl
# Date: 9 June, 2011
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: sortall.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Sort a collection of files.  



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

my %lines;

if($#ARGV < 0) { Syntax(); exit 0; }

foreach my $filename (glob ($ARGV[0]))
{
	print "\tsorting " . $filename . "...\n";

	my $file = IO::File($filename, "<") or croak "Unable to open \"" . $filename . "\": " . $OS_ERROR;

	while(my $line = <$file>)
	{
		chomp($line);

		next if length($line) == 0;

		$lines{$line}++;
	}

	close($file);


	$file = IO::File($filename, ">") or croak "Unable to open \"" . $filename . "\": " . $OS_ERROR;

	foreach my $line (sort keys %lines)
	{
		for(my $i=0; $i < $lines{$line}; $i++)
		{
			print $file $line . "\n";
		}
	}

	close($file);

	undef %lines;
}


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub Syntax
{
	print "\n";
	print "    ";
	print "syntax: sortall <filename(s)>";
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
