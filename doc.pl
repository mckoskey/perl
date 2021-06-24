#!/usr/bin/perl
#
# Name: doc.pl
# Date: 14 June, 2011
# Author: David McKoskey


use strict;
use warnings;
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use IO::File;
use Utilities;
use File::Basename;

if($#ARGV < 0) { syntax(); }

my $util = new Utilities();
my $today = $util->get_print_date();

my $filename = shift @ARGV;
my @extensions = qw(.tex);

my($title, $path, $extension) = fileparse($filename, @extensions);

$filename = $title;

if(! -e $filename . ".tex")      { $util->write_file($filename . ".tex",      get_main($filename)); }
if(! -e $filename . "_apa6.tex") { $util->write_file($filename . "_apa6.tex", get_main_apa6($filename)); }
if(! -e $filename . ".bib")      { $util->write_file($filename . ".bib",      get_main_bib($filename)); }
if(! -e "code_format.tex")       { $util->write_file("code_format.tex",       get_code_format()); }
if(! -e "course_info.sty")       { $util->write_file("course_info.sty",       get_course_info()); }
if(! -e "outline.tex")           { $util->write_file("outline.tex",           get_outline()); }
# if(! -e "abstract.tex")          { $util->write_file("abstract.tex",          get_abstract()); }
if(! -e "introduction.tex")      { $util->write_file("introduction.tex",      get_introduction()); }
if(! -e "conclusion.tex")        { $util->write_file("conclusion.tex",        get_conclusion()); }
if(! -e "make_links")            { $util->write_file("make_links",            get_make_links()); }
# if(! -e "draft.pro")             { $util->write_file("draft.pro",             get_draft_pro()); }
# if(! -e "copy.pro")              { $util->write_file("copy.pro",              get_copy_pro()); }
if(! -e "makefile")              { $util->write_file("makefile",              get_makefile($filename)); }
if(! -e "r.bat")                 { $util->write_file("r.bat",                 get_r_bat($filename)); }
if(! -e "run")                   { $util->write_file("run",                   get_run($filename)); }
if(! -e "edit.bat")              { $util->write_file("edit.bat",              get_edit_bat($filename)); }
if(! -e "edit")                  { $util->write_file("edit",                  get_edit($filename)); }


sub get_main
{
    my $filename   = shift;
    my $print_date = $util->get_print_date();
    my $title      = $util->get_title($filename);

    my $main_file=<<MAIN_FILE;
% Document: $filename.tex
% Date: $print_date
% Author: David McKoskey

\\documentclass[letterpaper, 12pt]{article}

%%%%% Packages %%%%%
\\usepackage{course_info}                % Course Information
% \\usepackage{pstricks}                   % Graphics
% \\usepackage{pst-node}                   % Parse Trees
% \\usepackage{pst-tree}
% \\usepackage{qtree}                      % Syntax Trees
\\usepackage[T1]{fontenc}                % T1 fonts
\\usepackage[natbibapa]{apacite}         % APA-style citations
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
\\usepackage{multirow}                   % Table multi row / column
\\usepackage{arydshln}                   %   \"   column dashed line
\\usepackage{colortbl}                   %   \"   cell color
\\usepackage{graphicx}                   % EPS Graphics files
% \\usepackage[dvipdfm]{hyperref}          % Creates hyperlink references to sections

%%%%% Colors %%%%%
% \\definecolor{lightgray}{rgb}{0.9,0.9,0.9} % rgb color model

%%%%% Global Variables %%%%%
% \\newcommand{\\figurewidth}{6.5in}
% \\newcommand{\\figureunitlength}{0.75 cm}

%%%%% Document Font Family %%%%%
\\renewcommand{\\familydefault}{\\rmdefault} % Roman / serif
% \\renewcommand{\\familydefault}{\\sfdefault} % Sans serif
% \\renewcommand{\\familydefault}{\\ttdefault} % Typeface

%%%%% Section Numbering %%%%%
\\setcounter{secnumdepth}{-1} % Turn off section numbering without removing them from the TOC

%%%%% Document Setup %%%%%
\\setlength{\\topmargin}{0in}         % Top margins
\\setlength{\\headheight}{0in}
\\setlength{\\voffset}{0in}
\\setlength{\\headsep}{0.5in}
\\setlength{\\topskip}{0in}
\\setlength{\\oddsidemargin}{0in}     % Side margins
\\setlength{\\evensidemargin}{-0.5in}
\\setlength{\\textwidth}{6.5in}       % Text width
\\setlength{\\textheight}{9in}        % Text height
% \\setlength{\\footskip}{0.5in}        % Bottom margins
% \\setlength{\\parindent}{0in}         % Paragraph indent
\\pagestyle{fancy}                    % Use Header and Footer by Default
% \\pagestyle{empty}                    % No page numbers
\\begin{document}

%%%%% Source Code Listing Style %%%%%
\\input{code_format}

%%%%% Header and Footer Information %%%%%
\\lhead{}
\\chead{}
\\rhead{}
\\lfoot{\\textsc{$title}}
\\cfoot{\\thepage/\\pageref{LastPage}}
\\rfoot{\\textsc{\\institutionName}}
\\renewcommand{\\headrulewidth}{0pt}   %   No line by default.  Change to 0.4pt for line.
\\renewcommand{\\footrulewidth}{0.4pt} % Thin line by default.

%%%%% Title Page %%%%%
\\title{$title}
\\author{\\courseAuthor}
\\date{}
\\maketitle
\\thispagestyle{empty} % no page number on first page

%%%%% Abstract %%%%%
% \\input{abstract}
% \\newpage

%%%%% TOC and Lists %%%%%
% \\tableofcontents
% \\listoffigures
% \\listoftables
% \\newpage

%%%%% Outline %%%%%
% \\input{outline}
% \\newpage

%%%%% Main Body %%%%%
\\input{introduction}
% \\input{}
\\input{conclusion}

%%%%% Appendix %%%%%
% \\newpage
% \\appendix
% \\include{}

% \\bibliographystyle{plain}
% \\bibliographystyle{alpha}
% \\bibliographystyle{chicago}
% \\bibliographystyle{apacite}
% \\bibliography{\\bibFileName,$filename}

\\end{document}
MAIN_FILE

    return $main_file;
}

sub get_main_apa6
{
    my $filename   = shift;
    my $print_date = $util->get_print_date();
    my $title      = $util->get_title($filename);

    my $main_file=<<MAIN_FILE;
% Document: $filename.tex
% Date: $print_date
% Author: David McKoskey

% jou (default): Formats the document with an appearance resembling a printed 
%                APA journal (e.g., Journal of Educational Psychology. The 
%                text is typeset in two-sided, two-column format.
% man: Formats the document in close (if not complete) compliance with the 
%                requirements for submission to an APA journal (e.g., title 
%                page, doublespacing, etc.).
% doc: Formats the document as a typical LATEX document (one-sided, 
%                singlecolumn, etc.)
\\documentclass[man, 12pt]{apa6}

%%%%% Packages %%%%%
\\usepackage{course_info}                % Course Information
% \\usepackage{pstricks}                   % Graphics
% \\usepackage{pst-node}                   % Parse Trees
% \\usepackage{pst-tree}
% \\usepackage{qtree}                      % Syntax Trees
\\usepackage[T1]{fontenc}                % T1 fonts
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
\\usepackage{lastpage}                   % Last Page Number
\\usepackage{lscape}                     % Landscape mode
\\usepackage{multirow}                   % Table multi row / column
\\usepackage{arydshln}                   %   \"   column dashed line
\\usepackage{colortbl}                   %   \"   cell color
\\usepackage{graphicx}                   % EPS Graphics files
% \\usepackage[dvipdfm]{hyperref}          % Creates hyperlink references to sections

\\usepackage[american]{babel}
\\usepackage{csquotes}
\\usepackage[style=apa,sortcites=true,sorting=nyt,backend=biber]{biblatex}
\\DeclareLanguageMapping{american}{american-apa}
\\addbibresource{\\bibFileName.bib}
\\addbibresource{$filename.bib}

%%%%% Title %%%%%
\\title{$title \\protect\\\\[\\baselineskip] Title Line Two}
\\shorttitle{$title}

%%%%% Author %%%%%
\\author{\\courseAuthor}
\\affiliation{\\institutionName}
\\leftheader{\\courseAuthor}
\\authornote{ Correspondence concerning this article should be addressed to 
              \\courseAuthor, \\departmentFullName, \\institutionName.  }

%%%%% Abstract %%%%%
\\abstract{Place abstract here}

%%%%% Keywords %%%%%
\\keywords{this, is, a, zither}

%%%%% Colors %%%%%
\\definecolor{lightgray}{rgb}{0.9,0.9,0.9} % rgb color model

%%%%% Global Variables %%%%%
\\newcommand{\\figurewidth}{6.5in}
\\newcommand{\\figureunitlength}{0.75 cm}

%%%%% Document Font Family %%%%%
\\renewcommand{\\familydefault}{\\rmdefault} % Roman / serif
% \\renewcommand{\\familydefault}{\\sfdefault} % Sans serif
% \\renewcommand{\\familydefault}{\\ttdefault} % Typeface

%%%%% Section Numbering %%%%%
% \\setcounter{secnumdepth}{-1} % Turn off section numbering without removing them from the TOC

%%%%% Source Code Listing Style %%%%%
\\input{code_format}

%%%%% Document Setup %%%%%
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
\\begin{document}

%%%%% Make the Title %%%%%
\\maketitle

%%%%% TOC and Lists %%%%%
\\tableofcontents
% \\listoffigures
% \\listoftables
\\newpage

%%%%% Outline %%%%%
\\input{outline}
\\newpage

%%%%% Main Body %%%%%
\\input{introduction}
% \\input{}
\\input{conclusion}

%%%%% Bibliography %%%%%
\\newpage
\\printbibliography

%%%%% Appendix %%%%%
% \\newpage
% \\appendix
% \\include{}

\\end{document}
MAIN_FILE

    return $main_file;
}

sub get_main_bib
{
    my $title = shift;

    my $main_bib=<<MAIN_BIB;
% Default bibliography for $title


MAIN_BIB

    return $main_bib;
}


sub get_outline
{
    my $outline=<<OUTLINE;
\\section[Outline]{Outline}\\label{sec:Outline}

\\begin{enumerate}
    \\item Introduction
    \\begin{enumerate}
        \\item 
        \\item 
        \\item 
    \\end{enumerate}
    \\item 
    \\begin{enumerate}
        \\item 
        \\item 
        \\item 
    \\end{enumerate}
    \\item 
    \\begin{enumerate}
        \\item 
        \\item 
        \\item 
    \\end{enumerate}
    \\item Conclusion
    \\begin{enumerate}
        \\item 
        \\item 
        \\item 
    \\end{enumerate}
\\end{enumerate}
OUTLINE

    return $outline;
}


sub get_abstract
{
    my $abstract=<<ABSTRACT;
\\begin{abstract}
Abstract goes here.
\\end{abstract}
ABSTRACT

    return $abstract;
}


sub get_code_format
{
    my $code_format=<<CODEFORMAT;
\\definecolor{darkred}{rgb}{0.75, 0.0, 0.75}
\\definecolor{darkgreen}{rgb}{0.0, 0.5, 0.0}
\\definecolor{darkblue}{rgb}{0.0, 0.0, 0.75}

\\lstset
{
    language=SQL,
    basicstyle=\\ttfamily\\scriptsize,
    keywordstyle=\\color{blue},
    commentstyle=\\color{green},
    stringstyle=\\color{mauve},
    stringstyle=\\ttfamily\\scriptsize,
    showstringspaces=false
}
CODEFORMAT

    return $code_format;
}

sub get_course_info
{
    my $course_info=<<COURSE_INFO;
% Course Author Information
\\newcommand{\\courseAuthor}{David McKoskey, Cohort 28}
% \\newcommand{\\courseAuthor}{David McKoskey}

% Institution Name
\\newcommand{\\institutionName}{University of St. Thomas}
% \\newcommand{\\institutionName}{St. Catherine University}

% Department Name
\\newcommand{\\departmentFullName}{Department of Leadership, Policy and Administration}
% \\newcommand{\\departmentFullName}{Department of Mathematics / Physics}
% \\newcommand{\\departmentFullName}{Department of Library and Information Science}

% Department Abbreviation
\\newcommand{\\departmentAbbreviation}{EDLD}
% \\newcommand{\\departmentAbbreviation}{CSCI}
% \\newcommand{\\departmentAbbreviation}{LIS}

% Course Number
\\newcommand{\\courseNumber}{911}
% \\newcommand{\\courseNumber}{1040}
% \\newcommand{\\courseNumber}{1050}
% \\newcommand{\\courseNumber}{7510}
% \\newcommand{\\courseNumber}{7963}

% BibTeX file name
\\newcommand{\\bibFileName}{edld911}
% \\newcommand{\\bibFileName}{csci1040}
% \\newcommand{\\bibFileName}{csci1050}
% \\newcommand{\\bibFileName}{lis7510}
% \\newcommand{\\bibFileName}{lis7963}

% Course Call Number
\\newcommand{\\courseCallNumber}{\\departmentAbbreviation\\ \\courseNumber}

% Slide Options
% \\newcommand{\\courseTheme}{CambridgeUS}
% \\newcommand{\\courseTheme}{Dresden}
\\newcommand{\\courseTheme}{JuanLesPins}
\\newcommand{\\courseColorTheme}{dolphin}
% \\newcommand{\\courseColorTheme}{seahorse}
% \\newcommand{\\courseColorTheme}{beaver}
% \\newcommand{\\courseColorTheme}{beetle}
% \\newcommand{\\courseColorTheme}{default}

% Full date
\\newcommand{\\weekOneDate}{Thursday February 6, 2014}
\\newcommand{\\weekTwoDate}{Thursday February 13, 2014}
\\newcommand{\\weekThreeDate}{Thursday February 20, 2014}
\\newcommand{\\weekFourDate}{Thursday February 27, 2014}

\\newcommand{\\weekFiveDate}{Thursday March 6, 2014}
\\newcommand{\\weekSixDate}{Thursday March 13, 2014}
\\newcommand{\\weekSevenDate}{Thursday March 20, 2014}
\\newcommand{\\weekEightDate}{Thursday March 27, 2014} % Easter / Spring Break

\\newcommand{\\weekNineDate}{Thursday April 3, 2014}
\\newcommand{\\weekTenDate}{Thursday April 10, 2014}
\\newcommand{\\weekElevenDate}{Thursday April 17, 2014}
\\newcommand{\\weekTwelveDate}{Thursday April 24, 2014}

\\newcommand{\\weekThirteenDate}{Thursday May 1, 2014}
\\newcommand{\\weekFourteenDate}{Thursday May 8, 2014}
\\newcommand{\\weekFifteenDate}{Thursday May 15, 2014}
\\newcommand{\\weekSixteenDate}{Thursday May 22, 2014}


% Shortened date
\\newcommand{\\shortWeekOneDate}{Feb. 6}
\\newcommand{\\shortWeekTwoDate}{Feb. 13}
\\newcommand{\\shortWeekThreeDate}{Feb. 20}
\\newcommand{\\shortWeekFourDate}{Feb. 27}

\\newcommand{\\shortWeekFiveDate}{Mar. 6}
\\newcommand{\\shortWeekSixDate}{Mar. 13}
\\newcommand{\\shortWeekSevenDate}{Mar. 20}
\\newcommand{\\shortWeekEightDate}{Mar. 27}

\\newcommand{\\shortWeekNineDate}{Apr. 3}
\\newcommand{\\shortWeekTenDate}{Apr. 10}
\\newcommand{\\shortWeekElevenDate}{Apr. 17}
\\newcommand{\\shortWeekTwelveDate}{Apr. 24}

\\newcommand{\\shortWeekThirteenDate}{May 1}
\\newcommand{\\shortWeekFourteenDate}{May 8}
\\newcommand{\\shortWeekFifteenDate}{May 15}
\\newcommand{\\shortWeekSixteenDate}{May 22}
COURSE_INFO

    return $course_info;
}

sub get_introduction
{
    my $introduction=<<INTRODUCTION;
\\section[Introduction]{Introduction}\\label{sec:Introduction}


INTRODUCTION

    return $introduction;
}


sub get_conclusion
{
    my $conclusion=<<CONCLUSION;
\\section[Conclusion]{Conclusion}\\label{sec:Conclusion}


CONCLUSION

    return $conclusion;
}


sub get_make_links
{
    my $make_links=<<MAKE_LINKS;
#!/bin/bash

rm -f course_info.sty
ln -s ../../../course_info.sty course_info.sty

rm -f code_format.tex
ln -s ../../../code_format.tex code_format.tex
MAKE_LINKS

    return $make_links;
}

sub get_draft_pro
{
    my $draft_pro=<<DRAFT_PRO;
userdict begin
/bop-hook{gsave
250 150 translate
65 rotate
/Times-Roman findfont 144 scalefont setfont
0 0 moveto 0.7 setgray (DRAFT) show grestore
} def end
DRAFT_PRO

    return $draft_pro;
}

sub get_copy_pro
{
    my $copy_pro=<<COPY_PRO;
userdict begin
/bop-hook{gsave
250 150 translate
65 rotate
/Times-Roman findfont 144 scalefont setfont
0 0 moveto 0.7 setgray (COPY) show grestore
} def end
COPY_PRO

    return $copy_pro;
}

sub get_makefile
{
    my $filename = shift;

    my $makefile=<<MAKEFILE;
FILE = $filename

LATEX     = latex
PDFLATEX  = pdflatex
BIBER     = biber
BIBTEX    = bibtex
DVIPS     = dvips
PS2PDF    = ps2pdf
LATEX2RTF = latex2rtf
PANDOC    = pandoc
VIEWER    = evince
COPY      = cp -f
REMOVE    = rm -f

all :
	make preclean
	make compile
	make latex2rtf # pandoc # latex2rtf
	make clean

compile :
	\${LATEX}     \${FILE}.tex
	\${BIBTEX}    \${FILE}
	\${LATEX}     \${FILE}.tex
	\${LATEX}     \${FILE}.tex

compile_apa6 :
	\${PDFLATEX}  \${FILE}_apa6.tex
	\${BIBER}     \${FILE}_apa6
	\${PDFLATEX}  \${FILE}_apa6.tex
	\${PDFLATEX}  \${FILE}_apa6.tex

compile_nobib :
	\${LATEX}     \${FILE}.tex
	\${LATEX}     \${FILE}.tex

latex2rtf :
	\${LATEX2RTF} \${FILE}.tex

pandoc :
	\${PANDOC} -s \${FILE}.tex -o \${FILE}.docx --bibliography \${FILE}.bib

view :
	\${VIEWER}    \${FILE}.dvi

ps :
	make all
	\${DVIPS}     \${FILE}.dvi
	\${REMOVE}    \${FILE}.dvi

pdf :
	make all
	dvipdfm -q    \${FILE}.dvi
	\${REMOVE}    \${FILE}.dvi

ps_pdf :
	make ps
	\${PS2PDF}    \${FILE}.ps
	\${REMOVE}    \${FILE}.ps

copy_ps :
	make all
	\${DVIPS} -h copy.pro \${FILE}.dvi
	\${REMOVE}    \${FILE}.dvi

copy_pdf :
	make all
	\${DVIPS} -h copy.pro \${FILE}.dvi
	\${PS2PDF}    \${FILE}.ps
	\${REMOVE}    \${FILE}.ps
	\${REMOVE}    \${FILE}.dvi

draft_ps :
	make all
	\${DVIPS} -h draft.pro \${FILE}.dvi
	\${REMOVE}    \${FILE}.dvi

draft_pdf :
	make all
	\${DVIPS} -h draft.pro \${FILE}.dvi
	\${PS2PDF}    \${FILE}.ps
	\${REMOVE}    \${FILE}.ps
	\${REMOVE}    \${FILE}.dvi

n_up_ps :
	make all
	\${DVIPS}     \${FILE}.dvi
	\${REMOVE}    \${FILE}.dvi
	psnup \${N_UP_FL} -pletter -m0in -\${N_UP} \${FILE}.ps \${N_UP}up\${FILE}.ps
	\${COPY}      \${N_UP}up\${FILE}.ps \${FILE}.ps
	\${REMOVE}    \${N_UP}up\${FILE}.ps

n_up_pdf :
	make n_up_ps
	\${PS2PDF}    \${FILE}.ps
	\${REMOVE}    \${FILE}.ps

release :
	make ps_pdf

allclean :
	make preclean
	make clean

preclean :
	\${REMOVE}    \${FILE}.ps
	\${REMOVE}    \${FILE}.pdf
	\${REMOVE}    \${FILE}_apa6.pdf
	\${REMOVE}    \${FILE}.dvi
	\${REMOVE}    \${FILE}.rtf
	\${REMOVE}    \${FILE}.docx

clean : 
	\${REMOVE} *.aux
	\${REMOVE} *.bcf
	\${REMOVE} *.bbl
	\${REMOVE} *.blg
	\${REMOVE} *.log
	\${REMOVE} *.lof
	\${REMOVE} *.lot
	\${REMOVE} *.out
	\${REMOVE} *.toc
	\${REMOVE} *.run.xml
MAKEFILE

    return $makefile;
}


sub get_r_bat
{
    my $filename = shift;

    my $r_bat=<<R_BAT;
\@echo off

title $filename

make release

if exist $filename.pdf start $filename.pdf
R_BAT

    return $r_bat;
}


sub get_run
{
    my $filename = shift;

    my $run=<<RUN;
#!/bin/bash

make release

if [[ -f $filename.pdf ]]
then
    evince $filename.pdf &
fi
RUN

    return $run;
}


sub get_edit_bat
{
    my $filename = shift;

    my $edit_bat=<<EDIT_BAT;
\@echo off

title $filename

start gvim outline.tex introduction.tex conclusion.tex
EDIT_BAT

    return $edit_bat;
}


sub get_edit
{
    my $filename = shift;

    my $edit=<<EDIT;
#!/bin/bash

wmctrl=`which wmctrl`

if [[ -n \${wmctrl} ]]
then
    wmctrl -r :ACTIVE: -N mckoskey_case-thumbnail_sketch
fi

gvim outline.tex introduction.tex conclusion.tex
EDIT

    return $edit;
}

sub syntax
{
    print "\n";
    print "\tSyntax: doc <filename(s)>\n";
    print "\n";
    print "\tNote: do not use wildcards\n";
    print "\n";
    exit -1;
}

#
# end script
#
