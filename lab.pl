#!/usr/bin/perl
#
# Name: lab.pl
# Date: 17 May, 2014
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

if(! -e $filename . ".tex")     { $util->write_file($filename . ".tex", get_main($filename)); }
if(! -e "code_format.tex")      { $util->write_file("code_format.tex",  get_code_format()); }
if(! -e "purpose.tex")          { $util->write_file("purpose.tex",      get_purpose()); }
if(! -e "exercises.tex")        { $util->write_file("exercises.tex",    get_exercises()); }
if(! -e "edit")                 { $util->write_file("edit",             get_edit()); }
if(! -e "edit.bat")             { $util->write_file("edit.bat",         get_edit_bat()); }
if(! -e "make_links")           { $util->write_file("make_links",       get_make_links()); }
if(! -e "makefile")             { $util->write_file("makefile",         get_makefile($filename)); }
if(! -e "r.bat")                { $util->write_file("r.bat",            get_r_bat($filename)); }
if(! -e "run")                  { $util->write_file("run",              get_run($filename)); }

foreach my $num (qw(1 2 3 4 5 6 7 8 9 10))
{
    my $exfilename = "exercise_" . $num . ".tex";

    if(! -e $exfilename) { $util->write_file($exfilename, get_exercise($num)); }
}


sub get_main
{
    my $filename   = shift;
    my $print_date = $util->get_print_date();
    my $title      = $util->get_title($filename);

    my $main_file=<<MAIN_FILE;
% Document: $filename.tex
% Date: $print_date
% Author: David McKoskey

\\documentclass[letterpaper, 11pt]{article}

%%%%% Packages %%%%%
\\usepackage{course_info}                % Course Information
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
\\usepackage[dvipdfm]{hyperref}          % Creates hyperlink references to sections

%%%%% Colors %%%%%
\\definecolor{lightgray}{rgb}{0.9,0.9,0.9} % rgb color model

%%%%% Global Variables %%%%%
\\newcommand{\\figurewidth}{6.5in}
\\newcommand{\\figureunitlength}{0.75 cm}

%%%%% Document Font %%%%%
\\renewcommand{\\familydefault}{\\sfdefault}

\\setcounter{secnumdepth}{-1} % Turn off section numbering without removing them from the TOC

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
\\setlength{\\parindent}{0in}         % Paragraph indent
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
% \\date{}
\\maketitle
\\thispagestyle{empty} % no page number on first page

%%%%% Abstract %%%%%
% \\input{abstract}
% \\newpage

%%%%% TOC and Lists %%%%%
\\tableofcontents
% \\listoffigures
% \\listoftables
\\newpage

%%%%% Main Body %%%%%
\\input{purpose}
\\input{exercises}
\\input{exercise_1}
\\input{exercise_2}
\\input{exercise_3}
\\input{exercise_4}
\\input{exercise_5}
\\input{exercise_6}
\\input{exercise_7}
\\input{exercise_8}
\\input{exercise_9}
\\input{exercise_10}
% \\input{}

%%%%% Appendix %%%%%
\\newpage
% \\appendix
% \\include{}

\\bibliographystyle{plain}
% \\bibliographystyle{alpha}
% \\bibliographystyle{apacite}
\\bibliography{\\bibFileName}

\\end{document}
MAIN_FILE

    return $main_file;
}


sub get_code_format
{
    my $code_format=<<CODEFORMAT;
\\definecolor{darkred}{rgb}{0.75, 0.0, 0.75}
\\definecolor{darkgreen}{rgb}{0.0, 0.5, 0.0}
\\definecolor{darkblue}{rgb}{0.0, 0.0, 0.75}

\\lstset
{
    language=PHP,
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


sub get_purpose
{
    my $purpose=<<PURPOSE;
\\section[Purpose]{Purpose}\\label{sec:Purpose}

\\cite{Nixon2012}

PURPOSE

    return $purpose;
}


sub get_exercises
{
    my $exercises=<<EXERCISES;
\\section[Exercises]{Exercises}\\label{sec:Exercises}


EXERCISES

    return $exercises;
}


sub get_exercise
{
    my $num = shift;

    my $exercise=<<EXERCISE;
\\section[Exercise $num]{Exercise $num}\\label{sec:Exercise$num}


EXERCISE

    return $exercise;
}


sub get_edit
{
    my $edit=<<EDIT;
#!/bin/bash

gvim purpose.tex exercises.tex exercise_1.tex exercise_2.tex exercise_3.tex exercise_4.tex exercise_5.tex exercise_6.tex exercise_7.tex exercise_8.tex exercise_9.tex exercise_10.tex
EDIT

    return $edit;
}


sub get_edit_bat
{
    my $edit_bat=<<EDIT_BAT;
\@echo off

start gvim purpose.tex exercises.tex exercise_1.tex exercise_2.tex exercise_3.tex exercise_4.tex exercise_5.tex exercise_6.tex exercise_7.tex exercise_8.tex exercise_9.tex exercise_10.tex
EDIT_BAT

    return $edit_bat;
}


sub get_make_links
{
    my $make_links=<<MAKE_LINKS;
#!/bin/bash

rm -f course_info.sty
ln -s ../../../course_info.sty course_info.sty

rm -f code_format.tex
ln -s ../../../code_format.tex code_format.tex

rm -f lis_7963.bib
ln -s ../../../lis_7963.bib lis_7963.bib
MAKE_LINKS

    return $make_links;
}


sub get_makefile
{
    my $filename = shift;

    my $makefile=<<MAKEFILE;
FILE = $filename

# UNIX or Linux
  LATEX     = latex
  BIBTEX    = bibtex
  DVIPS     = dvips
  PS2PDF    = ps2pdf
  VIEWER    = evince
  COPY      = cp -f
  REMOVE    = rm -f

# Win32 using MikTeX
# LATEX     = latex  -quiet
# BIBTEX    = bibtex -quiet
# DVIPS     = dvips  -q*
# PS2PDF    = ps2pdf
# VIEWER    = yap
# COPY      = copy /y
# REMOVE    = del /q

all :
	make preclean
	make compile
	make clean

compile :
	\${LATEX}  \${FILE}.tex
	\${BIBTEX} \${FILE}
	\${LATEX}  \${FILE}.tex
	\${LATEX}  \${FILE}.tex

compile_nobib :
	\${LATEX}  \${FILE}.tex
	\${LATEX}  \${FILE}.tex

view:
	\${VIEWER} \${FILE}.dvi

ps :
	make all
	\${DVIPS} \${FILE}.dvi
	\${REMOVE} \${FILE}.dvi

pdf :
	make all
	dvipdfm -q \${FILE}.dvi
	\${REMOVE} \${FILE}.dvi

ps_pdf :
	make ps
	\${PS2PDF} \${FILE}.ps
	\${REMOVE} \${FILE}.ps

copy_ps :
	make all
	\${DVIPS} -h copy.pro \${FILE}.dvi
	\${REMOVE} \${FILE}.dvi

copy_pdf :
	make all
	\${DVIPS} -h copy.pro \${FILE}.dvi
	\${PS2PDF} \${FILE}.ps
	\${REMOVE} \${FILE}.ps
	\${REMOVE} \${FILE}.dvi

draft_ps :
	make all
	\${DVIPS} -h draft.pro \${FILE}.dvi
	\${REMOVE} \${FILE}.dvi

draft_pdf :
	make all
	\${DVIPS} -h draft.pro \${FILE}.dvi
	\${PS2PDF} \${FILE}.ps
	\${REMOVE} \${FILE}.ps
	\${REMOVE} \${FILE}.dvi

n_up_ps :
	make all
	\${DVIPS} \${FILE}.dvi
	\${REMOVE} \${FILE}.dvi
	psnup \${N_UP_FL} -pletter -m0in -\${N_UP} \${FILE}.ps \${N_UP}up\${FILE}.ps
	\${COPY}   \${N_UP}up\${FILE}.ps \${FILE}.ps
	\${REMOVE} \${N_UP}up\${FILE}.ps

n_up_pdf :
	make n_up_ps
	\${PS2PDF} \${FILE}.ps
	\${REMOVE} \${FILE}.ps

release :
	make ps_pdf

allclean :
	make preclean
	make clean

preclean :
	\${REMOVE} \${FILE}.ps
	\${REMOVE} \${FILE}.pdf
	\${REMOVE} \${FILE}.dvi

clean : 
	\${REMOVE} *.aux
	\${REMOVE} *.log
	\${REMOVE} *.bbl
	\${REMOVE} *.blg
	\${REMOVE} *.toc
	\${REMOVE} *.lof
	\${REMOVE} *.lot
	\${REMOVE} *.out
MAKEFILE

    return $makefile;
}


sub get_r_bat
{
    my $filename = shift;

    my $r_bat=<<R_BAT;
\@echo off

make release

start $filename.pdf
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


sub syntax
{
    print "\n";
    print "\tSyntax: lab <filename(s)>\n";
    print "\n";
    print "\tNote: do not use wildcards\n";
    print "\n";
    exit -1;
}

#
# end script
#
