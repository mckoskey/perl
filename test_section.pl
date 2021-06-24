#!/usr/bin/perl

use strict;
use warnings;
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use IO::File;
use Utilities;
use File::Basename;
use Getopt::Long;
use Env qw(OS);

my $make_doc   = 0;
my $serif_font = 0;
my $apastyle   = 0;

GetOptions
(
    'a' => \$apastyle,
    'd' => \$make_doc,
    's' => \$serif_font,
);

if($#ARGV < 0) { Syntax(); }

my $util = new Utilities();

my $texfilename = shift @ARGV;
my @extensions = qw(.tex);

my %citations;

my ($title, $path, $extension) = fileparse($texfilename, @extensions);

my $importname     = $title;
my $outfiletexname = "temp.tex";
my $outfiledviname = "temp.dvi";
my $outfilertfname = $title . ".rtf";
my $outfilepsname  = "temp.ps";
my $outfilepdfname = $title . ".pdf";

cleanup("temp");

   my $outfiletex = IO::File->new($outfiletexname, '>') or croak "Unable to write \"" . $outfiletexname . "\": " . $OS_ERROR;

if(-s "translations.sty")
{
    print $outfiletex get_translations_header($serif_font);
}
else
{
    print $outfiletex get_standard_header($serif_font);
}

print $outfiletex "\n";
print $outfiletex "\\input{" . $importname . "}\n";
print $outfiletex "\n";

if(-s ($title . ".bib"))
{
    print $outfiletex get_references_footer($title, $apastyle);
}
else
{
    print $outfiletex get_standard_footer();
}

close $outfiletex;

my $output = `latex $outfiletexname 2>&1`;

if(-s ($title . ".bib"))
{
   $output = `bibtex temp 2>&1`;
   $output = `latex $outfiletexname 2>&1`;
}

   $output = `latex $outfiletexname 2>&1`;

if($make_doc)
{
    if($util->test_var($OS))
    {
        $output = `latex2rtf -o $outfilertfname    $outfiletexname 2>&1`;
    }
    else
    {
        $output = `pandoc    -s $outfiletexname -o $outfilertfname 2>&1`;
    }
}

# $output = `dvips  -o $outfilepsname $outfiledviname 2>&1`;
# $output = `ps2pdf    $outfilepsname $outfilepdfname 2>&1`;

$output = `dvipdfm -o $outfilepdfname $outfiledviname 2>&1`;

cleanup("temp");


sub get_standard_header
{
    my $serif_font = shift;
    my $font;

    if($serif_font)
    {
        $font = "\\sfdefault";
    }
    else
    {
        $font = "\\rmdefault";
    }

    my $header=<<HEADER;
\\documentclass[letterpaper, 12pt]{article}

% \\usepackage{pstricks}                   % Graphics
% \\usepackage{pst-node}                   % Parse Trees
% \\usepackage{pst-tree}
% \\usepackage{qtree}                      % Syntax Trees
\\usepackage[T1]{fontenc}                % T1 fonts
% \\usepackage{apacite}                    % APA-style citations
\\usepackage{enumitem}                   % Enumeration items
\\usepackage{amsfonts}                   % AMS Fonts
\\usepackage{amsmath}                    %  \"  Math
\\usepackage{amssymb}                    %  \"  Symbols
\\usepackage{bbding}                     % Dingbat Font
\\usepackage{textcomp}                   % Misc. Fonts
\\usepackage{epic}                       % Line Graphics
\\usepackage{eepic}
\\usepackage{ecltree}                    % Simple Trees
\\usepackage{color}                      % Color
\\usepackage{setspace}                   % Paragraph Spacing
\\usepackage{listings}                   % Source Code Formatting 
\\usepackage{marginnote}                 % Margin Notes
\\usepackage{fancyhdr}                   % Header and Footer Formatting
\\usepackage{lastpage}                   % Last Page Number
\\usepackage{lscape}                     % Landscape mode
% \\usepackage{array}                      % Array instead of table
\\usepackage{multirow}                   % Table multi row / column
\\usepackage{arydshln}                   %   \"   column dashed line
\\usepackage{colortbl}                   %   \"   cell color
\\usepackage{longtable}                  %   \"   across pages
\\usepackage{graphicx}                   % EPS Graphics files
% \\usepackage[dvipdfm]{hyperref}          % Creates hyperlink references to sections

%%%%% Colors %%%%%
\\definecolor{lightgray}{rgb}{0.9,0.9,0.9} % rgb color model
\\definecolor{darkred}{rgb}{0.75, 0.0, 0.75}
\\definecolor{darkgreen}{rgb}{0.0, 0.5, 0.0}
\\definecolor{darkblue}{rgb}{0.0, 0.0, 0.75}

%%%%% Global Variables %%%%%
\\newcommand{\\figurewidth}{6.5in}
\\newcommand{\\figureunitlength}{0.75 cm}

%%%%% Highlighter %%%%%
\\newcommand{\\highlight}[1]{\\colorbox{yellow}{#1}}

%%%%% Document Font Family %%%%%
\\renewcommand{\\familydefault}{$font}

% Single spacing for all quotes, despite double spacing elsewhere
\\expandafter\\def\\expandafter\\quote\\expandafter{\\quote\\onehalfspacing}

%%%%% Section Numbering %%%%%
\\setcounter{secnumdepth}{-1} % Turn off section numbering without removing them from the TOC

\\setlength{\\topmargin}{0in}         % Top margins
\\setlength{\\headheight}{0in}
\\setlength{\\voffset}{-0.4in}
\\setlength{\\headsep}{0.5in}
\\setlength{\\topskip}{0in}
\\setlength{\\oddsidemargin}{0in}     % Side margins
\\setlength{\\evensidemargin}{-0.5in}
\\setlength{\\textwidth}{6.5in}       % Text width
\\setlength{\\textheight}{9in}        % Text height
% \\setlength{\\footskip}{0.5in}        % Bottom margins
\\setlength{\\parindent}{0in}         % Paragraph indent
\\pagestyle{plain}                   % Simple page format

\\begin{document}

\\lstset
{
    language=Java,
    basicstyle=\\ttfamily\\scriptsize,
    keywordstyle=\\color{blue},
    commentstyle=\\color{green},
    stringstyle=\\color{mauve},
    stringstyle=\\ttfamily\\scriptsize,
    showstringspaces=false
}

HEADER

    return $header;
}

sub get_standard_footer
{
    my $footer=<<FOOTER;

\\end{document}
FOOTER

    return $footer;
}

sub get_translations_header
{
    my $serif_font = shift;
    my $font;

    if($serif_font)
    {
        $font = "\\sfdefault";
    }
    else
    {
        $font = "\\rmdefault";
    }

    my $header=<<HEADER;
\\documentclass[letterpaper, 12pt]{article}

\\usepackage{translations}               % Name translations
% \\usepackage{pstricks}                   % Graphics
% \\usepackage{pst-node}                   % Parse Trees
% \\usepackage{pst-tree}
% \\usepackage{qtree}                      % Syntax Trees
\\usepackage[T1]{fontenc}                % T1 fonts
% \\usepackage{apacite}                    % APA-style citations
\\usepackage{enumitem}                   % Enumeration items
\\usepackage{amsfonts}                   % AMS Fonts
\\usepackage{amsmath}                    %  \"  Math
\\usepackage{amssymb}                    %  \"  Symbols
\\usepackage{bbding}                     % Dingbat Font
\\usepackage{textcomp}                   % Misc. Fonts
\\usepackage{epic}                       % Line Graphics
\\usepackage{eepic}
\\usepackage{ecltree}                    % Simple Trees
\\usepackage{color}                      % Color
\\usepackage{setspace}                   % Paragraph Spacing
\\usepackage{listings}                   % Source Code Formatting 
\\usepackage{marginnote}                 % Margin Notes
\\usepackage{fancyhdr}                   % Header and Footer Formatting
\\usepackage{lastpage}                   % Last Page Number
\\usepackage{lscape}                     % Landscape mode
% \\usepackage{array}                      % Array instead of table
\\usepackage{multirow}                   % Table multi row / column
\\usepackage{arydshln}                   %   \"   column dashed line
\\usepackage{colortbl}                   %   \"   cell color
\\usepackage{longtable}                  %   \"   across pages
\\usepackage{graphicx}                   % EPS Graphics files
% \\usepackage[dvipdfm]{hyperref}          % Creates hyperlink references to sections

%%%%% Colors %%%%%
\\definecolor{lightgray}{rgb}{0.9,0.9,0.9} % rgb color model
\\definecolor{darkred}{rgb}{0.75, 0.0, 0.75}
\\definecolor{darkgreen}{rgb}{0.0, 0.5, 0.0}
\\definecolor{darkblue}{rgb}{0.0, 0.0, 0.75}

%%%%% Global Variables %%%%%
\\newcommand{\\figurewidth}{6.5in}
\\newcommand{\\figureunitlength}{0.75 cm}

%%%%% Highlighter %%%%%
\\newcommand{\\highlight}[1]{\\colorbox{yellow}{#1}}

%%%%% Document Font Family %%%%%
\\renewcommand{\\familydefault}{$font}

% Single spacing for all quotes, despite double spacing elsewhere
\\expandafter\\def\\expandafter\\quote\\expandafter{\\quote\\onehalfspacing}

%%%%% Section Numbering %%%%%
\\setcounter{secnumdepth}{-1} % Turn off section numbering without removing them from the TOC

\\setlength{\\topmargin}{0in}         % Top margins
\\setlength{\\headheight}{0in}
\\setlength{\\voffset}{-0.4in}
\\setlength{\\headsep}{0.5in}
\\setlength{\\topskip}{0in}
\\setlength{\\oddsidemargin}{0in}     % Side margins
\\setlength{\\evensidemargin}{-0.5in}
\\setlength{\\textwidth}{6.5in}       % Text width
\\setlength{\\textheight}{9in}        % Text height
% \\setlength{\\footskip}{0.5in}        % Bottom margins
\\setlength{\\parindent}{0in}         % Paragraph indent
\\pagestyle{plain}                   % Simple page format

\\begin{document}

\\lstset
{
    language=Java,
    basicstyle=\\ttfamily\\scriptsize,
    keywordstyle=\\color{blue},
    commentstyle=\\color{green},
    stringstyle=\\color{mauve},
    stringstyle=\\ttfamily\\scriptsize,
    showstringspaces=false
}

HEADER

    return $header;
}

sub get_references_footer
{
    my $title = shift;
    my $apastyle = shift;
    my $footer = "";

    if($apastyle)
    {
    $footer=<<FOOTER;
\\newpage

\\bibliographystyle{apalike}
\\bibliography{$title}

\\end{document}
FOOTER
    }
    else
    {
    $footer=<<FOOTER;
\\newpage

\\bibliographystyle{plain}
\\bibliography{$title}

\\end{document}
FOOTER
    }

    return $footer;
}

sub cleanup
{
    my $outfiletexname = shift;

    my @extensions = qw(.aux .log .bbl .blg .toc .lof .lot .out .dvi .tex .ps .rtf);

    foreach my $extension (@extensions)
    {
        my $filename = $outfiletexname . $extension;

        if(-f $filename)
        {
            unlink $filename;
        }
    }
}


sub Syntax
{
        print "\n";
        print "\tSyntax: test_section [-ads] <filename(s)>\n";
        print "\n";
        print "\tOptions:\n";
        print "\t        -a if bib file exists, use APA format.\n";
        print "\t        -d make RTF file in addition to PDF.\n";
        print "\t        -s use serif font.\n";
        print "\n";
        print "\tNote: do not use wildcards\n";
        print "\n";
        exit -1;
}

#
# end script
#
