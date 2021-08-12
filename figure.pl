#!/usr/bin/perl
#
# Name: figure.pl
# Date: 14 June, 2011
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: figure.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Create a LaTeX figure page.



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
        <td>June 14, 2011</td>
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
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use IO::File;
use Utilities;

if($#ARGV < 0) { Syntax(); }

my $util = new Utilities();
my $today = $util->get_print_date();

my @infiles = @ARGV;

foreach my $filename (@infiles)
{
	if($filename =~ /\*/)
	{
		print"\n\tERROR: WILDCARD.  Please enumerate file names\n\n";
		Syntax();
	}

    my $label_base = $filename;

	$filename = "figure_" . $filename;

	if(-e $filename)
	{
		print "File \"" . $filename . "\" exists, skipping...\n";
		next;
	}

	if($filename !~ /\.tex/)
	{
		$filename = $filename . ".tex";
	}

	if(-e $filename)
	{
		print "File \"" . $filename . "\" exists, skipping...\n";
		next;
	}

	my $file = IO::File->new($filename, ">") or croak "Unable to open \"" . $filename . "\": " . $OS_ERROR;

	print $file "\\begin{figure}[hptb]\n";
	print $file "\\begin{center}\n";
	print $file "\\colorbox{lightgray}{\n";
	print $file "\\begin{minipage}{\\figurewidth}\n";
	print $file "\\begin{center}\n";
	print $file "\\setlength{\\unitlength}{\\figureunitlength}\n";
	print $file "\\begin{picture}(width, height)\n";
	print $file "\n";
	print $file "\n";
	print $file "\\end{picture}\n";
	print $file "\\end{center}\n";
	print $file "\\caption{" . $util->get_title($label_base) . "}\n";
	print $file "\\label{figure:" . $util->get_label($label_base) . "}\n";
	print $file "\\end{minipage}\n";
	print $file "}\n";
	print $file "\\end{center}\n";
	print $file "\\end{figure}\n";

	close($file);

	print "\t\"" . $filename . "\" created.\n";
}


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub Syntax
{
	print "\n";
	print "\tSyntax: figure <filename(s)>\n";
	print "\n";
	print "\tNote: do not use wildcards\n";
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
