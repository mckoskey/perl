#!/usr/bin/perl
#
# Name: file_size.pl
# Date: 8 June, 2011
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: file_size.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Determine and show file sizes.  



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
        <td>June 8, 2011</td>
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
use File::Find;
use File::Path;
use File::Basename;

if($#ARGV < 0)
{
    syntax();
    exit(-1);
}

my $start_dir = shift @ARGV;
my %file_sizes;
my $max_file_length = 0;

print "Starting in directory \"" . $start_dir . "\".\n";

find(\&findFiles, $start_dir);

sub findFiles
{
    my $filename = $File::Find::name;

    if(-f $filename)
    {
        my $filesize = -s $filename;

        $file_sizes{$filename} = $filesize;

        if(length($filename) > $max_file_length) { $max_file_length = length($filename); }
    }
}

foreach my $filename (sort { $file_sizes{$a} <=> $file_sizes{$b} } keys %file_sizes)
{
    print $filename;
   
   for(my $i = 0; $i < $max_file_length + 4 - length($filename); $i++)
   {
       print " ";
   }

   print $file_sizes{$filename};
   print "\n";
}


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub syntax
{
    print "\n";
    print "    Syntax: " . $0  . " <start dir>\n";
    # print "\n";
}

=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
