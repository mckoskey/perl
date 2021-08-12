#!/usr/bin/perl
#
# Name: pod_postproc.pl
# Date: 9 June, 2011
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: pod_postproc.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Postprocess HTML output files from the "perldoc" utility.  Removes links and META tags, and indents the HTML for easy reading.  



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

my @infilenames = glob($ARGV[0]);

foreach my $infilename (@infilenames)
{
    next if $infilename =~ /index\.html/;

    print "grep -vi \"<meta\" " . $infilename . " > temp.html\n";
    print "copy temp.html " . $infilename . "\n";
    print "del temp.html\n";
    print "\n";
    print "call indent_xml -rs " . $infilename . "\n";
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
