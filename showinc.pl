#!/usr/bin/perl
#
# Name: showinc.pl
# Date: 18 April, 2006
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: showinc.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Show the paths in @INC (the Perl module path).  Knowing this, one can determine if the modules you're trying to use are available.  



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
        <td>April 18, 2006</td>
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

print "\n";
print "Here's the Perl \"\@INC\" path:\n";
print "\n";

foreach my $path (@INC)
{
    print "    ";
    print "path: \"" . $path . "\"\n";;
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
