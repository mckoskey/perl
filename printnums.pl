#!/usr/bin/perl
#
# Name: printnums.pl
# Date: 2 September, 1998
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: printnums.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Print a file with line numbers at the left edge of the console screen.  



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
        <td>September 2, 1998</td>
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


#!/usr/bin/perl
#
# name: printnums
# author: David McKoskey

use strict;
use warnings;
use Carp;
use English;
use IO::File;
use Getopt::Std;                # include lib for getopts
use vars qw($opt_s $opt_p);
getopts('sp:');                  # get options
if ($#ARGV < 0) { syntax (); }  # require one parameters

my $file = IO::File->new("$ARGV[0]", "<") or croak "Unable to open \"" . $ARGV[0] . "\": " . $OS_ERROR;
my $count = 1;  # initialize counter
my $indent = 0;
my $printline;

while (my $line = <$file>)
{
	if(length($count) < 5) { $indent = 5 - length($count); }
	else { print "\n\tIndent too small, exiting\n\n"; exit (1); }

	if (defined($opt_s) && $opt_s == 1) 
	{ 
		$printline = substr($line, 0, length($line) - length($count) - $indent - 2); 
		$printline = $printline . "\n";
	}
	else { $printline = $line }

	if ($opt_p)
	{
		if ($line =~ /$opt_p/) 
		{ 
			# for (my $i = 0; $i<=$indent + length($count); $i++) { print " "; }
			print "$printline";
		}
		else { PrintRegular($count, $indent, $printline); $count++; }
	}
	else { PrintRegular($count, $indent, $printline); $count++; } 
}

close ($file);


=pod

=head4 PrintRegular()

Print the numbers on the left margin.  

=cut
sub PrintRegular
{
	print "$_[0]";
	for (my $i = 0; $i<=$_[1]; $i++) { print " "; }
	print "$_[2]"; 
}


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub syntax
{
	printf ("\n\t printnums: show file columns\n");
	printf ("\t    syntax: printnums \-ppattern \<file\>\n");
	printf ("\t   options:  \-ppattern skip lines that contain specified pattern\n");
	printf ("\t   options:  \-s  static line length\n");
	printf ("\n");
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
