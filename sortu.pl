#!/usr/bin/perl
#
# Name: sortu.pl
# Date: 9 June, 2011
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: sortu.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Sort the contents of a file uniquely.  



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


if($#ARGV < 0) { Syntax(); }

use strict;
use warnings;

use English;
use Carp;
use IO::File;
use Getopt::Std;
use vars qw($opt_r);
getopts('r');

my @infiles = glob($ARGV[0]);

foreach my $infilename (@infiles)
{
    my %items;

    my $infile = IO::File->new($infilename, "<") or croak "Unable to open \"" . $infilename . "\": " . $OS_ERROR;

    while(my $line = <$infile>)
    {
        chomp($line);
        next if length($line) == 0;
        if(!$items{$line}) { $items{$line} = 1; }
    }

    close($infile);

    if($opt_r)
    {
        my $tempfile = IO::File->new("tmp.txt", ">") or croak "Unable to open \"tmp.txt\": " . $OS_ERROR;

        foreach my $item (sort keys %items)
        {
            print $tempfile $item . "\n";
        }

        close($tempfile);

        # $command = "del /y " . $infilename;
        my $command = "rm " . $infilename;
        system($command);

        # $command = "move /y tmp.txt " . $infilename;
        $command = "mv tmp.txt " . $infilename;

        system($command);
    }
    else
    {
        foreach my $item (sort keys %items)
        {
            print $item . "\n";
        }
    }
}


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub Syntax
{
    print "\n";
    print "\tsyntax: sortu <filename(s)>\n";
    print "\n";
    print "\toptions:  \-r  replace original input file with sorted\n";
    print "\n";
    exit 0;
}


=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
