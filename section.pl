#!/usr/bin/perl
#
# Name: section.pl
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
use Getopt::Long;

my $make_bib     = 0;
my $make_run     = 0;
my $make_edit    = 0;
my $make_cleanup = 0;

GetOptions
(
    'b' => \$make_bib,
    'r' => \$make_run,
    'e' => \$make_edit,
    'c' => \$make_cleanup,
);

if($#ARGV < 0) { Syntax(); }

my $util = new Utilities();
my $today = $util->get_print_date();

my @infiles = @ARGV;
my @extensions = qw(.tex);

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

	print $file "% " . $util->get_print_date() . "\n";
	print $file "% \\section[" . $util->get_title($filename) . "]{" . $util->get_title($filename) . "}\\label{sec:" . $util->get_label ($filename) . "}\n";
	print $file "\\section{" . $util->get_title($filename) . "}\n";
	print $file "\n";
	print $file "\n";

	close $file;

	print "\t\"" . $filename . "\" created.\n";

    my($title, $path, $extension) = fileparse($filename, @extensions);

    if($make_bib)
    {
        my $bibname = $path . $title . ".bib";

	    $file = IO::File->new($bibname, ">") or croak "Unable to open \"" . $bibname . "\": " . $OS_ERROR;

        print $file "% Bibliography for " . $util->get_title($filename) . "\n";
        print $file "\n";
        print $file "\n";

	    close $file;

	    print "\t\"" . $title . ".bib\" created.\n";
    }

    make_run($title)        if $make_run;
    make_edit($filename)    if $make_edit;
    make_cleanup($filename) if $make_cleanup;
}

sub make_run {
    my $filetitle = shift;

    my $run=<<RUN;
#!/bin/bash

test_section $filetitle.tex

if [[ -f $filetitle.pdf ]]
then
    evince $filetitle.pdf &
fi
RUN

    my $run_bat=<<RUN_BAT;
\@echo off

call test_section $filetitle.tex

start $filetitle.pdf if exist $filetitle.pdf
RUN_BAT

    $util->write_file("run", $run);
    $util->write_file("r.bat", $run_bat);
}

sub make_edit {
    my $filename = shift;

    my $edit=<<EDIT;
#!/bin/bash

gvim $filename
EDIT

    my $edit_bat=<<EDIT_BAT;
\@echo off

start gvim $filename
EDIT_BAT

    $util->write_file("edit", $edit);
    $util->write_file("edit.bat", $edit_bat);
}

sub make_cleanup {
    my $filename = shift;

    my $cleanup=<<CLEANUP;
#!/bin/bash

rm -f *.pdf
CLEANUP

    my $cleanup_bat=<<CLEANUP_BAT;
\@echo off

del /q *.pdf
CLEANUP_BAT

    $util->write_file("cleanup", $cleanup);
    $util->write_file("cleanup.bat", $cleanup_bat);
}

sub Syntax
{
	print "\n";
	print "\tSyntax: section <filename(s)>\n";
	print "\n";
	print "\tOptions:\n";
	print "          -b make empty bib file for section\n";
	print "          -r make run files for section\n";
	print "          -e make edit files for section\n";
	print "          -c make cleanup files for section\n";
	print "\n";
	print "\tNote: do not use wildcards\n";
	print "\n";
	exit -1;
}

#
# end script
#
