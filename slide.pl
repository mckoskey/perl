#!/usr/bin/perl

use strict;
use warnings;
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use IO::File;
use Utilities;
use Getopt::Long;

my $fragile = undef;
my $twocolumn = undef;

GetOptions
(
    't' => \$twocolumn,
    'f' => \$fragile,
);

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

	print $file "\\section[" . $util->get_title($filename) . "]{" . $util->get_title($filename) . "}\\label{sec:" . $util->get_label ($filename) . "}\n";
	print $file "\n";

    if($util->test_var($fragile))
    {
	    print $file "\\begin{frame}[fragile]\n";
	    print $file "\n";
	    print $file "\\frametitle{" . $util->get_title($filename) . "}\n";
	    print $file "\n";
	    print $file "Let me tell you what I'm doing.\\\\[0.25cm]\n";
	    print $file "\n";
	    print $file "\\pause\n";
	    print $file "\n";
	    print $file "Below is a source code example.\\\\[0.25cm]\n";
	    print $file "\n";
	    print $file "\\pause\n";
	    print $file "\n";
	    print $file "\\begin{lstlisting}\n";
	    print $file "\\end{lstlisting}\n";
    }
    elsif ($util->test_var($twocolumn))
    {
	    print $file "\\begin{frame}\n";
	    print $file "\n";
	    print $file "\\frametitle{" . $util->get_title($filename) . "}\n";
	    print $file "\n";
	    print $file "\\begin{columns}\n";
	    print $file "\\begin{column}{0.5\\textwidth}\n";
	    print $file "\n";
	    print $file "\\onslide<1->\n";
	    print $file "{\n";
	    print $file "}\n";
	    print $file "\n";
	    print $file "\\begin{itemize}\n";
	    print $file "    \\item<2-> \n";
	    print $file "    \\item<3-> \n";
	    print $file "    \\item<4-> \n";
	    print $file "\\end{itemize}\n";
	    print $file "\n";
	    print $file "\\end{column}\n";
	    print $file "\n";
	    print $file "\n";
	    print $file "\\begin{column}{0.5\\textwidth}\n";
	    print $file "\\begin{center}\n";
	    print $file "\\begin{figure}\n";
	    print $file "\\includegraphics[width=2in]{mypicture.eps}\n";
	    print $file "\\caption{This is my picture.}\n";
	    print $file "\\end{figure}\n";
	    print $file "\\end{center}\n";
	    print $file "\\end{column}\n";
	    print $file "\n";
	    print $file "\\end{columns}\n";
    }
    else
    {
	    print $file "\\begin{frame}\n";
	    print $file "\n";
	    print $file "\\frametitle{" . $util->get_title($filename) . "}\n";
	    print $file "\n";
	    print $file "\\onslide<1->\n";
	    print $file "{\n";
	    print $file "}\n";
	    print $file "\n";
	    print $file "\\begin{itemize}\n";
	    print $file "    \\item<2-> \n";
	    print $file "    \\item<3-> \n";
	    print $file "    \\item<4-> \n";
	    print $file "\\end{itemize}\n";
    }

	print $file "\n";
	print $file "\\end{frame}\n";

	close($file);

	print "\t\"" . $filename . "\" created.\n";
}


sub Syntax
{
	print "\n";
	print "\tSyntax: slide <filename(s)>\n";
	print "\n";
	print "\tNote: do not use wildcards\n";
	print "\n";
	exit -1;
}

#
# end script
#
