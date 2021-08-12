#!/usr/bin/perl
#
# name: cols
# date: 26 August, 1998
# author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: cols.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Show the column numbers for a file.  



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
        <td>August 26, 1998</td>
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
use Getopt::Std;
use Term::ReadKey;
use vars qw($opt_h $opt_f);

getopts('h:f:s');                       # get options
if ($#ARGV < 0) { Syntax (); exit 0; }  # require one parameters

my $num_rows = 0;
my ($wchar, $hchar, $wpixels, $hpixels) = GetTerminalSize();

# override screen height
if(defined($opt_h) && length($opt_h) > 0 && $opt_h <= $hchar)
{
    $hchar = $opt_h;
}

if(defined($opt_f)) { printCols($opt_f, $wchar); }
else                { printCols(10, $wchar); }

my $file = IO::File->new("$ARGV[0]", "<") or croak "Unable to open \"" . $ARGV[0] . "\": " . $OS_ERROR;

while (my $line = <$file>)
{
    chomp $line;

    if($num_rows > $hchar - 3)
    {
        if(defined($opt_f)) { printCols($opt_f, $wchar); }
        else                { printCols(10, $wchar); }

        $num_rows = 0;
    }
    else
    {
        $num_rows++;
    }

    print $line;
    print "\n";
}

close $file;

=pod

=head4 printCols(scale, screen width)

This function that prints column numbers, based on the "ruler" scale of the output
and the width of the display screen.  By default, the scale is 10 and the width
is the number of console columns.  

=cut
sub printCols
{
	my $factor = shift;
    my $width = shift;
    my $counter = 1;

    for(my $i = 0; $i < $width; $i++)
    {
	    for(my $j = 1; $j <= $factor; $i++, $j++) # print digit
	    {
		    if( $j % $factor == 0) 
		    {
			    print $counter % 10; 
			    $counter++; 
		    }
		    else
            {
                if(($j % (int $factor / 2)) == 0)
                {
                    print "+";
                }
                else
                {
                    print "-";
                }
            }
	    }
	}

	print "\n"; # add newline to the whole mess
}


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.  

=cut
sub Syntax
{
    print "\n";
    print "    ";
	print " syntax: cols \-ffactor -s \<file\>";
    print "\n";
    print "    ";
	print "options:  \-s scale  ruler scale (default 10)";
    print "\n";
    print "    ";
	print "          \-h        page height (default screen height)";
    print "\n";
	print "";
}

=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
