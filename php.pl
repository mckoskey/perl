#!/usr/bin/perl
#
# Name: php.pl
# Date: 27 November, 2013
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: page.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Create a template web page with a specified name.  



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
        <td>November 27, 2013</td>
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
use Getopt::Std;
use vars qw($opt_c);
getopts('c');

if($#ARGV < 0) { syntax(); }

my $util = new Utilities();

my @infiles = @ARGV;

foreach my $filename (@infiles)
{
	if($filename =~ /\*/)
	{
		print"\n\tERROR: WILDCARD.  Please enumerate file names\n\n";
		Syntax();
	}

	if(-e $filename)
	{
		print "File \"" . $filename . "\" exists, skipping...\n";
		next;
	}

	if($filename !~ /\.php/)
	{
		$filename = $filename . ".php";
	}

	if(-e $filename)
	{
		print "File \"" . $filename . "\" exists, skipping...\n";
		next;
	}

	my $file = IO::File->new($filename, ">") or croak "Unable to open \"" . $filename . "\": " . $OS_ERROR;

	print $file "<html>\n";
	print $file "<head>\n";
	print $file "<title>" . $util->get_title($filename) . "</title>\n";
	print $file "<link rel=\"stylesheet\" type=\"text/css\" href=\"default.css\"/>\n";

	print $file "</head>\n";
	print $file "<body>\n";
	print $file "\n";
	print $file "<h3>" . $util->get_title($filename) . "</h3>\n";
	print $file "\n";

	if($opt_c)
	{
		print $file "<a name=\"contents\"><h4>Contents</h4></a>\n";
		print $file "<ul>\n";
		print $file "\t<li><a href=\"#introduction\">Introduction</a></li>\n";
		print $file "\t<li><a href=\"#\"></a></li>\n";
		print $file "\t<li><a href=\"#\"></a></li>\n";
		print $file "\t<li><a href=\"#references\">References</a></li>\n";
		print $file "</ul>\n";
		print $file "\n";
		print $file "<a name=\"introduction\"><h4>Introduction</h4></a>\n";
		print $file "\n";
		print $file "<p></p>\n";
		print $file "\n";
		print $file "<p></p>\n";
		print $file "\n";
		print $file "<a href=\"#contents\">Back to Contents</a>\n";
		print $file "\n";
		print $file "<a name=\"\"><h4></h4></a>\n";
		print $file "\n";
		print $file "<p></p>\n";
		print $file "\n";
		print $file "<p></p>\n";
		print $file "\n";
		print $file "<a href=\"#contents\">Back to Contents</a>\n";
		print $file "\n";
		print $file "<a name=\"\"><h4></h4></a>\n";
		print $file "\n";
		print $file "<p></p>\n";
		print $file "\n";
		print $file "<p></p>\n";
		print $file "\n";
		print $file "<a href=\"#contents\">Back to Contents</a>\n";
		print $file "\n";
		print $file "<a name=\"references\"><h4>References</h4></a>\n";
		print $file "\n";
		print $file "<p></p>\n";
		print $file "\n";
		print $file "<p></p>\n";
		print $file "\n";
		print $file "<a href=\"#contents\">Back to Contents</a>\n";
	}
	else
	{
		print $file "<p></p>\n";
		print $file "\n";
		print $file "<p></p>\n";
		print $file "\n";
		print $file "<?php\n";
		print $file "\n";
		print $file "\n";
		print $file "\n";
		print $file "?>\n";
	}
	print $file "\n";
	print $file "</body>\n";
	print $file "</html>\n";

	close($file);

	print "\t\"" . $filename . "\" created.\n";
}


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub syntax
{
	print "\n";
	print "\tSyntax: page [-c] <filename(s)>\n";
	print "\n";
	print "\toptions: \-c add \"Contents\" section\n";
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
