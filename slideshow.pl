#!/usr/bin/perl
#
# Name: slideshow.pl
# Date: 28 November, 2011
# Author: David McKoskey

use strict;
use warnings;
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use IO::File;
use Utilities;

if($#ARGV < 0) { syntax(); }

my $util = new Utilities();
my $today = $util->get_print_date();

my $filename = shift @ARGV;

# Compile files
if(! -e "make_links")               { $util->write_file("make_links",               get_make_links()); }
if(! -e "makefile")                 { $util->write_file("makefile",                 get_makefile($filename)); }
if(! -e "r.bat")                    { $util->write_file("r.bat",                    get_r_bat($filename)); }
if(! -e "run")                      { $util->write_file("run",                      get_run($filename)); }
if(! -e "edit.bat")                 { $util->write_file("edit.bat",                 get_edit_bat($filename)); }
if(! -e "edit")                     { $util->write_file("edit",                     get_edit($filename)); }

if(! -e "edit")                     { $util->write_file("edit",                     get_edit($filename)); }
if(! -e "edit.bat")                 { $util->write_file("edit.bat",                 get_edit_bat($filename)); }

# Main slideshow files
if(! -e $filename . ".tex")         { $util->write_file($filename . ".tex",         get_main_slide($filename)); }
if(! -e $filename . "_handout.tex") { $util->write_file($filename . "_handout.tex", get_main_handout_slide($filename)); }
if(! -e $filename . "_notes.tex")   { $util->write_file($filename . "_notes.tex",   get_main_notes_slide($filename)); }
if(! -e $filename . ".bib")         { $util->write_file($filename . ".bib",         get_bibliography()); }

# Assisting slideshow files
if(! -e "code_format.tex")          { $util->write_file("code_format.tex",          get_code_format()); }
if(! -e "course_info.sty")          { $util->write_file("course_info.sty",          get_course_info()); }
if(! -e "presentation_slides.tex")  { $util->write_file("presentation_slides.tex",  get_presentation_slides()); }
if(! -e "title_page.tex")           { $util->write_file("title_page.tex",           get_title_page($filename)); }
if(! -e "outline.tex")              { $util->write_file("outline.tex",              get_outline()); }

# Standard slides
if(! -e "overview.tex")             { $util->write_file("overview.tex",             get_overview()); }
if(! -e "introduction.tex")         { $util->write_file("introduction.tex",         get_introduction()); }
if(! -e "conclusion.tex")           { $util->write_file("conclusion.tex",           get_conclusion()); }
if(! -e "questions.tex")            { $util->write_file("questions.tex",            get_questions()); }
if(! -e "references.tex")           { $util->write_file("references.tex",           get_references($filename)); }


sub get_main_slide
{
    my $filename = shift;

    my $title = $util->get_title($filename);
    my $print_date = $util->get_print_date();

    my $main_slide=<<MAIN_SLIDE;
% Document: $filename
% Date: $print_date
% Author: David McKoskey
    
\\documentclass{beamer}
    
%%%%% Packages %%%%%
\\usepackage{course_info}                % Course Information
\\usepackage{amsfonts}                   % AMS Fonts
\\usepackage{amsmath}                    %  \"  Math
\\usepackage{amssymb}                    %  \"  Symbols
% \\usepackage{pstricks}                   % Parse Trees
% \\usepackage{pst-node}
% \\usepackage{pst-tree}
\\usepackage{apacite}                    % APA-style citations
\\usepackage{epic}                       % Line Graphics
\\usepackage{eepic}
\\usepackage{color}                      % Color
\\usepackage{setspace}                   % Paragraph Spacing
\\usepackage{listings}                   % Source Code Formatting 
\\usepackage{comment}                    % Block Comments
\\usepackage{lscape}                     % Landscape mode
\\usepackage{multirow}                   % Table multi row / column
\\usepackage{colortbl}                   % Table color
\\usepackage{graphicx}                   % Import Images
    
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
    
%%%%% Set Figure Caption %%%%%
\\setbeamertemplate{caption}{\\raggedright\\insertcaption\\par}

%%%%% Source Code Listing Style %%%%%
\\input{code_format}
    
%%%%% Title Page %%%%%
\\input{title_page}
    
%%%%% Presentation %%%%%
\\input{presentation_slides}
    
\\end{document}
MAIN_SLIDE

    return $main_slide;
}

sub get_main_handout_slide
{
    my $filename = shift;

    my $title = $util->get_title($filename);
    my $print_date = $util->get_print_date();

    my $main_slide_handout=<<MAIN_SLIDE_HANDOUT;
% Document: $filename
% Date: $print_date
% Author: David McKoskey
    
\\documentclass[handout]{beamer}
    
%%%%% Packages %%%%%
\\usepackage{course_info}                % Course Information
\\usepackage{amsfonts}                   % AMS Fonts
\\usepackage{amsmath}                    %  \"  Math
\\usepackage{amssymb}                    %  \"  Symbols
% \\usepackage{pstricks}                   % Parse Trees
% \\usepackage{pst-node}
% \\usepackage{pst-tree}
\\usepackage{epic}                       % Line Graphics
\\usepackage{eepic}
\\usepackage{color}                      % Color
\\usepackage{setspace}                   % Paragraph Spacing
\\usepackage{listings}                   % Source Code Formatting 
\\usepackage{comment}                    % Block Comments
\\usepackage{lscape}                     % Landscape mode
\\usepackage{multirow}                   % Table multi row / column
\\usepackage{colortbl}                   % Table color
\\usepackage{graphicx}                   % Import Images
    
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
    
%%%%% Set Figure Caption %%%%%
\\setbeamertemplate{caption}{\\raggedright\\insertcaption\\par}

%%%%% Source Code Listing Style %%%%%
\\input{code_format}
    
%%%%% Title Page %%%%%
\\input{title_page}
    
%%%%% Presentation %%%%%
\\input{presentation_slides}
    
\\end{document}
MAIN_SLIDE_HANDOUT

    return $main_slide_handout;
}

sub get_main_notes_slide
{
    my $filename = shift;

    my $title = $util->get_title($filename);
    my $print_date = $util->get_print_date();
    my $handoutfilename = $filename . "_handout.pdf";

    my $main_slide_notes=<<MAIN_SLIDE_NOTES;
\\documentclass[letterpaper]{article}

\\usepackage[top=1cm,left=1.5cm,right=1.5cm,bottom=2cm]{geometry}
\\usepackage{course_info}
\\usepackage{fancyhdr}
\\usepackage{lastpage}
\\usepackage{pdfpages}

\\pagestyle{fancy}

\\lhead{}
\\chead{}
\\rhead{}
\\lfoot{\\textsc{\\courseCallNumber:\ $title}}
\\cfoot{\\thepage/\\pageref{LastPage}}
\\rfoot{\\textsc{\\institutionName}}
\\renewcommand{\\headrulewidth}{0pt}   %   No line by default.  Change to 0.4pt for line.
\\renewcommand{\\footrulewidth}{0.4pt} % Thin line by default.

\\begin{document}
\\includepdfmerge[nup=2x3, landscape=false, frame=false, pagecommand={\\thispagestyle{fancy}}, noautoscale=true, scale=0.8, delta=0 5]{$handoutfilename, 1,
                                                                                                                                      notes_page.pdf, 1,
                                                                                                                                      $handoutfilename, 2,
                                                                                                                                      notes_page.pdf, 1,
                                                                                                                                      $handoutfilename, 3,
                                                                                                                                      notes_page.pdf, 1,
                                                                                                                                      $handoutfilename, 4,
                                                                                                                                      notes_page.pdf, 1,
                                                                                                                                      $handoutfilename, 5,
                                                                                                                                      notes_page.pdf, 1}
\\end{document}
MAIN_SLIDE_NOTES

    return $main_slide_notes;
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

sub get_title_page
{
    my $title = shift;

    my $title_page=<<TITLE_PAGE;
\\title[\\courseCallNumber: $title]{\\courseCallNumber: $title}
\\author[\\courseAuthor]{\\courseAuthor}
\\date{}
\\institute[\\institutionName]{\\departmentFullName \\\\ \\institutionName}
\\subject{\\courseCallNumber: $title}
\\maketitle
% \\thispagestyle{empty} % no page number on title page
TITLE_PAGE

    return $title_page;
}

sub get_presentation_slides
{
    my $presentation_slides=<<PRESENTATION_SLIDES;
% \\input{overview}
\\input{introduction}

% \\input{}

\\input{conclusion}
% \\input{references}
PRESENTATION_SLIDES

    return $presentation_slides;
}

sub get_overview
{
    my $overview=<<OVERVIEW;
\\section[Overview]{Overview}\\label{sec:Overview}
    
\\frame
{
    \\frametitle{Overview}
    
    \\tableofcontents
}
OVERVIEW

    return $overview;
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
    
\\begin{frame}
    
\\frametitle{Introduction}
    
\\onslide<1->
{
}
    
\\begin{itemize}
    \\item<2-> 
    \\item<3-> 
    \\item<4-> 
\\end{itemize}
    
\\end{frame}
INTRODUCTION

    return $introduction;
}

sub get_conclusion
{
    my $conclusion=<<CONCLUSION;
\\section[Conclusion]{Conclusion}\\label{sec:Conclusion}
    
\\begin{frame}
    
\\frametitle{Conclusion}
    
\\onslide<1->
{
}
    
\\begin{itemize}
    \\item<2-> 
    \\item<3-> 
    \\item<4-> 
\\end{itemize}
    
\\end{frame}
CONCLUSION

    return $conclusion;
}

sub get_questions
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

sub get_references
{
    my $filename = shift;

    my $references=<<REFERENCES;
\\section[References]{References}\\label{sec:References}


\\begin{frame}[allowframebreaks]

\\frametitle{References}

\\bibliographystyle{plain}
% \\bibliographystyle{alpha}
% \\bibliographystyle{apalike}
% \\bibliographystyle{apacite}
\\bibliography{\\bibFileName,$filename}

\\end{frame}
REFERENCES

    return $references;
}


sub get_bibliography
{
    my $bibliography=<<BIBLIOGRAPHY;


%%%%% References Cited by the Above %%%%%

BIBLIOGRAPHY

    return $bibliography;
}


sub get_make_links
{
    my $make_links=<<MAKE_LINKS;
#!/bin/bash

rm -f course_info.sty
ln -s ../../../course_info.sty course_info.sty

rm -f notes_page.pdf
ln -s ../../../notes_page/notes_page.pdf notes_page.pdf

rm -f code_format.tex
ln -s ../../../code_format.tex code_format.tex
MAKE_LINKS

    return $make_links;
}

sub get_makefile
{
    my $filename = shift;

    my $makefile=<<MAKEFILE;
FILE = $filename
HANDOUT = handout
NOTES = notes

# UNIX or Linux
  LATEX     = latex
  PDFLATEX  = pdflatex
  BIBTEX    = bibtex
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
    \${BIBTEX} \${FILE}
    \${LATEX}  \${FILE}.tex
    \${LATEX}  \${FILE}.tex
    \${DVIPS}  \${FILE}.dvi
    \${REMOVE} \${FILE}.dvi
    \${PS2PDF} \${FILE}.ps
    \${REMOVE} \${FILE}.ps

compile_handout :
    \${LATEX}  \${FILE}_\${HANDOUT}.tex
    \${BIBTEX} \${FILE}_\${HANDOUT}
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


sub get_r_bat
{
    my $filename = shift;

    my $r_bat=<<R_BAT;
\@echo off

make release

$filename.pdf
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

sub get_edit
{
    my $filename = shift;

    my $edit=<<EDIT;
#!/bin/bash

gvim title_page.tex presentation_slides.tex
EDIT

    return $edit;
}

sub get_edit_bat
{
    my $filename = shift;

    my $edit_bat=<<EDIT_BAT;
\@echo off

gvim title_page.tex presentation_slides.tex
EDIT_BAT

    return $edit_bat;
}


sub syntax
{
    print "\n";
    print "\tSyntax: slideshow <filename(s)>\n";
    print "\n";
    print "\tNote: do not use wildcards\n";
    print "\n";
    exit -1;
}

#
# end script
#
