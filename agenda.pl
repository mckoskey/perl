#!/usr/bin/perl

use strict;
use warnings;
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use IO::File;
use Utilities;
use Getopt::Long;

my $class_number = undef;
my $continued    = undef;

GetOptions
(
    'n' => \$continued,
    'c=s' => \$class_number,
);

my $util = new Utilities();

croak "ERROR: No week specified." unless $util->test_var($class_number);

$class_number = "0" . $class_number if length($class_number) < 2;

my %number_words = (
    "1" => "One",
    "2" => "Two",
    "3" => "Three",
    "4" => "Four",
    "5" => "Five",
    "6" => "Six",
    "7" => "Seven",
    "8" => "Eight",
    "9" => "Nine",
    "10" => "Ten",
    "11" => "Eleven",
    "12" => "Twelve",
    "13" => "Thirteen",
    "14" => "Fourteen",
    "15" => "Fifteen",
    "16" => "Sixteen",
    "17" => "Seventeen",
);

my $main_slide_name = "class_" . $class_number . "_agenda";

if($util->test_var($continued))
{
    $main_slide_name .= "_continued";
}

$main_slide_name .= ".tex";


# Main program coordination.  The rest is in subroutines.
if(! -e "make_links")             { $util->write_file("make_links",             get_make_links()); }
if(! -e "makefile")               { $util->write_file("makefile",               get_makefile($class_number, $continued)); }
if(! -e "r.bat")                  { $util->write_file("r.bat",                  get_r_bat($class_number, $continued)); }
if(! -e "run")                    { $util->write_file("run",                    get_run($class_number, $continued)); }
if(! -e "edit.bat")               { $util->write_file("edit.bat",               get_edit_bat()); }
if(! -e "edit")                   { $util->write_file("edit",                   get_edit()); }
if(! -e $main_slide_name)         { $util->write_file($main_slide_name,         get_main_slide($class_number, $continued)); }
if(! -e "agenda.tex")             { $util->write_file("agenda.tex",             get_agenda_slide()); }
if(! -e "next_time.tex")          { $util->write_file("next_time.tex",          get_next_time_slide()); }
if(! -e "questions.tex")          { $util->write_file("questions.tex",          get_questions_slide()); }


sub get_make_links
{
    my $make_links=<<MAKE_LINKS;
#!/bin/bash

rm -f course_info.sty
ln -s ../../../course_info.sty course_info.sty

rm -f notes_page.pdf
ln -s ../../../notes_page/notes_page.pdf notes_page.pdf
MAKE_LINKS

    return $make_links;
}

sub get_makefile
{
    my $class_number = shift;
    my $continued   = shift;

    my $filename = "class_" . $class_number . "_agenda";
    
    if($util->test_var($continued))
    {
        $filename .= "_continued";
    }

    my $makefile=<<MAKEFILE;
FILE = $filename
HANDOUT = handout
NOTES = notes

# UNIX or Linux
  LATEX     = latex
  PDFLATEX  = latex
  DVIPS     = dvips
  PS2PDF    = ps2pdf
  VIEWER    = evince
  COPY      = cp -f
  REMOVE    = rm -f

# Win32 using MikTeX
# LATEX     = latex     --quiet
# PDFLATEX  = pdflatex  --quiet
# VIEWER    = yap
# COPY      = copy /y
# REMOVE    = del /q

all :
        make preclean
        make compile_slides
        make compile_handout
        make compile_notes
        make clean

compile_slides :
        \${LATEX}  \${FILE}.tex
        \${LATEX}  \${FILE}.tex
        \${DVIPS}  \${FILE}.dvi
        \${REMOVE} \${FILE}.dvi
        \${PS2PDF} \${FILE}.ps
        \${REMOVE} \${FILE}.ps

compile_handout :
        \${LATEX}  \${FILE}_\${HANDOUT}.tex
        \${LATEX}  \${FILE}_\${HANDOUT}.tex
        \${DVIPS}  \${FILE}_\${HANDOUT}.dvi
        \${REMOVE} \${FILE}_\${HANDOUT}.dvi
        \${PS2PDF} \${FILE}_\${HANDOUT}.ps
        \${REMOVE} \${FILE}_\${HANDOUT}.ps

compile_notes :
        \${PDFLATEX} \${FILE}_\${NOTES}.tex
        \${PDFLATEX} \${FILE}_\${NOTES}.tex
        \${REMOVE}   \${FILE}_\${HANDOUT}.pdf

release :
        make all

allclean :
        make preclean
        make clean

preclean :
        \${REMOVE} \${FILE}.ps
        \${REMOVE} \${FILE}.pdf
        \${REMOVE} \${FILE}.dvi
        \${REMOVE} \${FILE}_\${HANDOUT}.ps
        \${REMOVE} \${FILE}_\${HANDOUT}.pdf
        \${REMOVE} \${FILE}_\${HANDOUT}.dvi
        \${REMOVE} \${FILE}_\${NOTES}.ps
        \${REMOVE} \${FILE}_\${NOTES}.pdf
        \${REMOVE} \${FILE}_\${NOTES}.dvi

clean :
        \${REMOVE} *.aux
        \${REMOVE} *.log
        \${REMOVE} *.bbl
        \${REMOVE} *.blg
        \${REMOVE} *.toc
        \${REMOVE} *.lof
        \${REMOVE} *.lot
        \${REMOVE} *.nav
        \${REMOVE} *.out
        \${REMOVE} *.snm
        \${REMOVE} *.vrb
MAKEFILE

    return $makefile;
}

sub get_main_slide
{
    my $class_number = shift;
    my $continued   = shift;
    my $continued_string = "";

    $class_number = int $class_number; # strip leading zero
    my $class_date = "week" . get_number_word($class_number) . "Date";

    if($util->test_var($continued))
    {
        $continued_string = ", Continued";
        $class_date = "week" . get_number_word($class_number) . "Cont";
    }


    my $main_slide=<<MAIN_SLIDE;
\\documentclass{beamer}

%%%%% Packages %%%%%
\\usepackage{course_info}                % Course Information
\\usepackage{amsfonts}                   % AMS Fonts
\\usepackage{amsmath}                    %  "  Math
\\usepackage{amssymb}                    %  "  Symbols
\\usepackage{epic}                       % Line Graphics
\\usepackage{eepic}
\\usepackage{color}                      % Color
\\usepackage{setspace}                   % Paragraph Spacing
\\usepackage{listings}                   % Source Code Formatting
\\usepackage{lscape}                     % Landscape mode
\\usepackage{multirow}                   % Table multi row / column
\\usepackage{colortbl}                   % Table color
\\usepackage{arydshln}                   % Table dashed rows and columns

%%%%% Base Beamer Classes %%%%%
\\usepackage{beamerthemesplit}
\\usetheme{\\courseTheme}
\\usecolortheme{\\courseColorTheme}

%%%%% Colors %%%%%
\\definecolor{lightgray}{rgb}{0.9,0.9,0.9} % rgb color model

%%%%% Global Variables %%%%%
\\newcommand{\\figurewidth}{6.5in}
\\newcommand{\\figureunitlength}{0.75 cm}

\\begin{document}

%%%%% Title Page %%%%%
\\title[\\courseCallNumber\ : Week $class_number Agenda$continued_string]{\\courseCallNumber\\ Week $class_number: Agenda$continued_string}
\\author{\\courseAuthor}
\\date{\\$class_date}
\\institute[\\institutionName]{\\departmentFullName \\\\ \\institutionName}
\\subject{\\courseCallNumber\ : Week $class_number Agenda$continued_string}
\\maketitle
% \\thispagestyle{empty} % no page number on title page

%%%%% Presentation %%%%%
\\input{agenda}
\\input{next_time}
% \\input{questions}

\\end{document}
MAIN_SLIDE

    return $main_slide;
}

sub get_agenda_slide
{
    my $agenda=<<AGENDA;
\\section[Agenda]{Agenda}\\label{sec:Agenda}

\\begin{frame}

\\frametitle{Agenda}

\\onslide<1->
{
}

\\begin{itemize}
    \\item<2-> 
    \\item<3-> 
    \\item<4-> 
\\end{itemize}

\\end{frame}
AGENDA

    return $agenda;
}

sub get_next_time_slide
{
    my $next_time=<<NEXT_TIME;
\\section[Next Time]{Next Time}\\label{sec:NextTime}

\\begin{frame}

\\frametitle{Next Time}

\\onslide<1->
{
}

\\begin{itemize}
    \\item<2-> 
    \\item<3-> 
    \\item<4-> Complete and submit any lab work not finished tonight by Monday.
\\end{itemize}

\\end{frame}
NEXT_TIME

    return $next_time;
}

sub get_questions_slide
{
    my $questions=<<QUESTIONS;
\\section[Questions]{Questions}\\label{sec:Questions}

\\begin{frame}

% \\frametitle{Questions}

\\begin{center}
{ \\Huge Questions ? }
\\end{center}

\\end{frame}
QUESTIONS

    return $questions;
}

sub get_r_bat
{
    my $class_number = shift;
    my $continued   = shift;

    my $filename = "class_" . $class_number . "_agenda";

    if($util->test_var($continued))
    {
        $filename .= "_continued";
    }

    my $r_bat=<<R_BAT;
\@echo off

make release

start $filename.pdf
R_BAT

    return $r_bat;
}

sub get_run
{
    my $class_number = shift;
    my $continued   = shift;

    my $filename = "class_" . $class_number . "_agenda";

    if($util->test_var($continued))
    {
        $filename .= "_continued";
    }

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
    my $edit_bat=<<EDIT_BAT;
\@echo off

start gvim agenda.tex next_time.tex
EDIT_BAT

    return $edit_bat;
}

sub get_edit
{
    my $edit=<<EDIT;
#!/bin/bash

gvim agenda.tex next_time.tex
EDIT

    return $edit;
}

sub get_number_word
{
    my $class_number = shift;

    $class_number = int $class_number;

    return $number_words{$class_number};
}
