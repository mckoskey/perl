#!/usr/bin/perl


use strict;
use warnings;
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use IO::File;
use Getopt::Std;
use Utilities;

my $util = new Utilities();
# my $prefix = shift @ARGV;
# $prefix = 'sketch' unless defined($prefix) && length($prefix) > 0;
my $today = $util->get_print_date();
my $short_today = $util->get_short_date();
# my $filename = $prefix . "_" . $util->get_file_date() . ".tex";
my $filename = $util->get_file_date() . "_plan.tex";

if(! -e $filename)
{
	my $file = IO::File->new($filename, ">") or croak "Unable to create \"" . $filename . "\": " . $OS_ERROR;

	print $file "\\subsection[". $short_today . ": Work Plan]{Work Plan as of " . $today . "}\\label{subsec:" . $short_today . "WorkPlan}\n";
	print $file "\n";
	print $file "\\begin{enumerate}\n";
	print $file "    \\item Plan Outline\n";
	print $file "    \\begin{itemize}\n";
	print $file "        \\item \n";
	print $file "        \\item \n";
	print $file "        \\item \n";
	print $file "    \\end{itemize}\n";
	print $file "    \\item \n";
	print $file "    \\begin{itemize}\n";
	print $file "        \\item \n";
	print $file "        \\item \n";
	print $file "        \\item \n";
	print $file "    \\end{itemize}\n";
	print $file "    \\item \n";
	print $file "    \\begin{itemize}\n";
	print $file "        \\item \n";
	print $file "        \\item \n";
	print $file "        \\item \n";
	print $file "    \\end{itemize}\n";
	print $file "    \\item \n";
	print $file "    \\begin{itemize}\n";
	print $file "        \\item \n";
	print $file "        \\item \n";
	print $file "        \\item \n";
	print $file "    \\end{itemize}\n";
	print $file "\\end{enumerate}\n";

	close($file);
}

# system("start gvim $filename");
system("gvim $filename &");
