#!/usr/bin/perl
#
# Name: sleep.pl
# Date: 9 June, 2011
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: sleep.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Sleep a desired number of seconds.  For use with other scripts.  



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

=cut


use strict;
use warnings;

use English;
$OUTPUT_AUTOFLUSH = 1;

my $seconds = shift @ARGV;

if(defined($seconds) && $seconds > 0)
{
    print "Sleeping for " . $seconds . " seconds...";
    sleep $seconds;
    print " Done.\n";
}
else
{
    print "\n";
    print "\tSyntax perl sleep.pl <seconds>\n";
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
