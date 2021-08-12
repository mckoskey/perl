#!/usr/bin/perl
#
# Name: letter.pl
# Date: 14 June, 2011
# Author: David McKoskey

use strict;
use warnings;
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use IO::File;
use Utilities;
use Getopt::Long;
use File::Basename;

my $quote = undef;

GetOptions
(
    'q=s' => \$quote,
);

if($#ARGV < 0) { Syntax(); }

my $util = new Utilities();
my $today = $util->get_print_date();

if($util->test_var($quote))
    { $quote = "\\hspace*{2in} ``" . $quote . ".''"; }
else
    { $quote = "\\hspace*{2in} ``This is a zither.'' -- David McKoskey"; }

my $filename = shift @ARGV;

if($filename =~ /\*/)
{
    print"\n\tERROR: WILDCARD.  Please enumerate file names\n\n";
    Syntax();
}

if(-e $filename)
{
    print "File \"" . $filename . "\" exists, skipping...\n";
    exit 0;
}

if($filename !~ /\.tex/)
{
    $filename = $filename . ".tex";
}

if(-e $filename)
{
    print "File \"" . $filename . "\" exists, exiting.\n";
    exit 0;
}

my $file = IO::File->new($filename, ">") or croak "Unable to open file \"" . $filename . "\": " . $OS_ERROR;

print $file "% Document: " . $filename . "\n";
print $file "% Date: " . $util->get_print_date() . "\n";
print $file "% Author: David McKoskey\n";
print $file "\n";
print $file "\\documentclass[letterpaper, 11pt]{letter}\n";
print $file "\n";
print $file "\\usepackage{pstricks}\n";
print $file "\\usepackage{fancyhdr}\n";
print $file "\n";
print $file "%%%%% Document Setup %%%%%\n";
print $file "\\setlength{\\topmargin}{0.5in}        % top margins\n";
print $file "\\setlength{\\headheight}{0in}\n";
print $file "\\setlength{\\headsep}{0in}\n";
print $file "\\setlength{\\topskip}{0in}\n";
print $file "\\setlength{\\oddsidemargin}{0in}      % side margins\n";
print $file "\\setlength{\\evensidemargin}{0in}\n";
print $file "\\setlength{\\textwidth}{6.5in}        % text width\n";
print $file "\\setlength{\\textheight}{8.5in}       % text height\n";
print $file "% \\setlength{\\footskip}{1in}           % bottom margins\n";
print $file "% \\pagestyle{empty}                    % no header and footer\n";
print $file "\\pagestyle{fancy}                    % add header or footer (or both)\n";
print $file "\n";
print $file "%%%%% Document Font Family %%%%%\n";
print $file "\\renewcommand{\\familydefault}{\\rmdefault} % Roman / serif\n";
print $file "% \\renewcommand{\\familydefault}{\\sfdefault} % Sans serif\n";
print $file "% \\renewcommand{\\familydefault}{\\ttdefault} % Typeface\n";
print $file "\n";
print $file "%%%%% Notary Public %%%%%\n";
print $file "\\newcommand\\notarypublic{%\n";
print $file "\\begin{tabular}{|p{2in}|p{2in}|}\n";
print $file "\\hline\n";
print $file "\\multicolumn{2}{|c|}{Sworn before me in \\underline{\\hspace*{2.25in}}}\\\\\n";
print $file "\\multicolumn{2}{|c|}{on the \\underline{\\hspace*{2cm}} day of \\underline{\\hspace*{3cm}}, 20\\underline{\\hspace*{1cm}}}\\\\\n";
print $file "\\hline\n";
print $file "Signature & Seal \\\\\n";
print $file "          &      \\\\\n";
print $file "          &      \\\\\n";
print $file "          &      \\\\\n";
print $file "\\hline\n";
print $file "\\multicolumn{2}{|l|}{Commission Expires:}\\\\\n";
print $file "\\hline\n";
print $file "\\end{tabular}%\n";
print $file "}\n";
print $file "\n";
print $file "%%%%% Smileys! %%%%%\n";
print $file "% \\smiley or \\frowny\n";
print $file "\\begingroup\n";
print $file "    \\def\\facewith#1{\$\\bigcirc\\mskip-13.3mu{}^{..}\n";
print $file "    \\mskip-11mu\\scriptscriptstyle#1\\ \$}\n";
print $file "    \\xdef\\frowny{\\facewith\\frown}\n";
print $file "    \\xdef\\smiley{\\facewith\\smile}\n";
print $file "\\endgroup\n";
print $file "\n";
print $file "\\begin{document}\n";
print $file "\n";
print $file "%%%%% Title Information %%%%%\n";
print $file "\\date{" . $util->get_print_date() . "}\n";
print $file "\\begin{letter}{Mr. Somebody \\\\ 1234 Pleasant St.  \\\\ St. Paul, MN  55101}\n";
print $file "\\address{David McKoskey \\\\ 1976 Pinehurst Ave. \\\\ St. Paul, MN 55116}\n";
print $file "% \\address{David McKoskey \\\\ 1976 Pinehurst Ave. \\\\ St. Paul, MN 55116 \\\\ Tel: 651-500-2968}\n";
print $file "\\opening{Dear Sir,}\n";
print $file "% \\signature{David McKoskey \\\\[1cm] \\notarypublic}\n";
print $file "\\signature{David McKoskey}\n";
print $file "\n";
print $file "%%%%% Header and Footer Information %%%%%\n";
print $file "\\lhead{}\n";
print $file "\\chead{}\n";
print $file "\\rhead{}\n";
print $file "\\lfoot{}\n";
print $file "\\cfoot{" . $quote . "}\n";
print $file "\\rfoot{}\n";
print $file "\\renewcommand{\\headrulewidth}{0pt}   %   No line by default.  Change to 0.4pt for line.\n";
print $file "\\renewcommand{\\footrulewidth}{0.4pt} % Thin line by default.\n";
print $file "\n";
print $file "%%%%% Page Specifications %%%%%\n";
print $file "\\thispagestyle{fancy}\n";
print $file "\\raggedbottom\n";
print $file "\\raggedright\n";
print $file "\n";
print $file "%%%%%%%%%%%%%%%%% LETTER BODY %%%%%%%%%%%%%%%%\n";
print $file "\n";
print $file "\n";
print $file "\\closing{Sincerely,}\n";
print $file "% \\encl{Stuff for You}\n";
print $file "% \\cc{Dewey \\\\ Cheatham \\\\ Howe}\n";
print $file "\\end{letter}\n";
print $file "\\end{document}\n";

close($file);

my @extensions = qw(.tex);
my($name, $path, $extension) = fileparse($filename, @extensions);

unless (-e "r.bat")
{
    my $r_bat = IO::File->new("r.bat", ">") or croak "Unable to write r.bat: " . $OS_ERROR;

    print $r_bat "\@echo off\n";
    print $r_bat "\n";
    print $r_bat ":* cls\n";
    print $r_bat "\n";
    print $r_bat "if exist " . $name . ".pdf del " . $name . ".pdf\n";
    print $r_bat "\n";
    print $r_bat "pdflatex " . $name . ".tex\n";
    print $r_bat "pdflatex " . $name . ".tex\n";
    print $r_bat "\n";
    print $r_bat "del *.aux\n";
    print $r_bat "del *.log\n";
    print $r_bat "\n";
    print $r_bat "if exist " . $name . ".pdf start " . $name . ".pdf\n";

    close $r_bat;
}


sub Syntax
{
    print "\n";
    print "    Syntax: letter [-q] <filename(s)>\n";
    print "        -q <quote at the bottom of the page>\n";
    print "\n";
    print "    Note: do not use wildcards\n";
    print "\n";

    exit -1;
}

#
# end script
#
