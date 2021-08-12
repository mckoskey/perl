#!/usr/bin/perl
#
# Name: unix2dos
# Date: 18 April, 2005
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: unix2dos.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Change text file from DOS to UNIX format



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
        <td>April 18, 2005</td>
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
use Carp;
use English;
use IO::File;
use File::Copy;

  my @infilenames = @ARGV;
  my $tempfilename = "/tmp/mckoskey_temp.txt";

# my @infilenames = glob($ARGV[0]);
# my $tempfilename = "c:/tmp/mckoskey_temp.txt";

foreach my $infilename (@infilenames)
{
	print "\tprocessing $infilename...\n";

	my $infile   = IO::File->new($infilename, "<")   or croak "Unable to open \"" . $infilename   . "\": " . $OS_ERROR;
	my $tempfile = IO::File->new($tempfilename, ">") or croak "Unable to open \"" . $tempfilename . "\": " . $OS_ERROR;

	while(my $line = <$infile>)
	{
        chomp $line;

		print $tempfile $line;
		print $tempfile "\r";
		print $tempfile "\n";
	}
	
	close($tempfile);
	close($infile);

	copy($tempfilename, $infilename);
	unlink $tempfilename;
}

print "\n\tDone!\n\n";


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub Syntax
{
	print "\n\tsyntax: unix2dos <files>\n\n";
	exit(-1);
}


=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
