#!/usr/bin/perl
#
# Name: ljust
# Date: 10 September, 1998
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: ljust.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Left justify an entire file.



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
        <td>September 10, 1998</td>
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

if ($#ARGV < 0) { syntax (); }  # require one parameters

my $file = IO::File->new($ARGV[0], "<") or croak "Unable to open " . $ARGV[0] . ": " . $OS_ERROR;

while (my $line = <$file>)
{
	my $length = length($line) - 1;

	for(my $i = 0; $i<=$length; $i++) # remove whitespace from beginning of line
	{
		if(substr($line, 0, 1) =~ /\s/) { $line = substr($line, 1); }
		else { last; }
	}

	print $line;
}

close ($file);


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub syntax
{
	printf ("\n\t  ljust: left justify file contents\n");
	printf ("\t syntax: ljust \<file\>\n\n");
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
