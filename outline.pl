#!/usr/bin/perl

use strict;
use warnings;
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use Utilities;

my $util = new Utilities();

if(! -e "outline.tex") { $util->write_file("outline.tex", get_outline()); }


sub get_outline
{
    my $outline=<<OUTLINE;
\\section[Outline]{Outline}\\label{sec:Outline}

\\begin{enumerate}[label*=\\arabic*.]
    \\item Introduction
    \\begin{enumerate}[label*=\\arabic*.]
        \\item 
        \\item 
        \\item 
    \\end{enumerate}
    \\item 
    \\begin{enumerate}[label*=\\arabic*.]
        \\item 
        \\item 
        \\item 
    \\end{enumerate}
    \\item 
    \\begin{enumerate}[label*=\\arabic*.]
        \\item 
        \\item 
        \\item 
    \\end{enumerate}
    \\item Conclusion
    \\begin{enumerate}[label*=\\arabic*.]
        \\item 
        \\item 
        \\item 
    \\end{enumerate}
\\end{enumerate}
OUTLINE

    return $outline;
}
