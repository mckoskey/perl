#!/usr/bin/perl
#
# Name: pathfind.pl
# Date: 9 June 2011
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: pathfind.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Find a specified item in the environment path (%PATH% or $PATH).  



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

=cut


use strict;
use warnings;

if($#ARGV < 0) { syntax(); }

my @dirs;
my $file = $ARGV[0];

if($ENV{PATH} =~ /\//) # unix
{
	@dirs = split /:/, $ENV{PATH};

	foreach my $dir (@dirs)
	{
		my $path = $dir . "\/" . $file;

		print "Checking \"" . $dir . "\"\n";

		if(-e $path)
		{
			print "\t\"" . $file . "\" found in " . $dir . "\n";
		}

		print "\n";
	}
}
else # win32
{
	@dirs = split /;/, $ENV{PATH};

	foreach my $dir (@dirs)
	{
		my $path = $dir . "\\" . $file;

		print "Checking \"" . $dir . "\"\n";

		if(-e $path)
		{
			print "\t\"" . $file . "\" found in " . $dir . "\n";
		}

		print "\n";
	}
}


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub syntax
{
	print"\n\tSyntax: pathfind <filename>\n\n";
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
