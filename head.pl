#!/usr/bin/perl
#
# Name: head.pl
# Date: 8 June, 2011
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: head.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Show the first X (default 25) lines of a file.  Similar to the UNIX "head" command. 



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


if($#ARGV < 0) { Syntax(); }

use strict;
use warnings;

use Carp;
use English;
use IO::File;
use Getopt::Std;
use vars qw($opt_f $opt_l $opt_v);
getopts('fl:v');

  my @infiles = glob($ARGV[0]);
# my @infiles = @ARGV

$opt_l ||= 25;

for(my $j = 0; $j <= $#infiles; $j++)
{
    my $infile = $infiles[$j];

    if($opt_v)
    {
        print "File: \"" . $infile . "\"\n";
    }

	my $i = 0;
	my $file = IO::File->new($infile, "<") or croak "Unable to open file" . $infile . ": " . $OS_ERROR;

	while(my $line = <$file>)
	{ 
		last if(++$i > $opt_l);

		if($#infiles > 0)
		{
			if($opt_f) { print "$infile\t$line"; }
			else { print "$line"; }
		}
		else { print "$line"; }
	}

	close $file;

    if($j < $#infiles)
    {
	    print "\n";
	    print "\n";
    }
}


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub Syntax
{
	print "\n";
	print "\tSyntax: head [-l] <filename>\n";
	print "\n";
	print "\toptions:\n";
	print "\t        -f print file name on each line\n";
	print "\t        -l lines to display (default 25)\n";
	print "\t        -v prints file name heading (\"verbose\")\n";
	print "\n";

	exit -1;
}


=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
