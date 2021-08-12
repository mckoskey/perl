#!/usr/bin/perl
#
# Name: makeindex.pl
# Date: 4 January, 2001
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: makeindex.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Read a directory (pwd only or recursively) and create an index.html file of all HTML pages.



=head2 Revision History

=begin html

<table border="1" style="border-collapse : collapse" cellpadding="10">
    <tr>
        <th bgcolor="tan">Name</th>
        <th bgcolor="tan">Date</th>
        <th bgcolor="tan">Description</th>
    </tr>
    <tr>
        <td>David McKoskey</td>
        <td>January 4, 1998</td>
        <td>Initial Revision</td>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td></td>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td></td>
    </tr>
</table>

=end html

=head2 Functions

=cut


use strict;
use warnings;

use Carp;
use English;
use IO::File;
use File::Find;
use File::Path;
use File::Basename;
use Getopt::Std;
use vars qw($opt_a $opt_e $opt_h $opt_r $opt_t);
getopts('ae:hrt:');

my @extensions = qw(htm html xml php);
my $title;

my (%files, %directories);

if(defined($opt_h)) { syntax(); }

if(defined($opt_t)) { $title = $opt_t; }
else { $title = "Index Page"; }

if(defined($opt_e))
{
    @extensions = split /\s+/, $opt_e;
}

if(-f "index.html")
{
    print "ERROR: \"index.html\" found, stopping";
    syntax();
}

if($opt_r)
{
    find(\&process_tree, ".");

    my $index = IO::File->new("index.html", ">") or croak "Unable to open \"index.html\: " . $OS_ERROR;
    open($index, ">index.html");

    print $index "<html>\n";
    print $index "<head>\n";
    print $index "<title>" . $title . "</title>\n";
    print $index "<link rel=\"stylesheet\" type=\"text/css\" href=\"default.css\"/>\n";
    print $index "</head>\n";
    print $index "<body>\n";
    print $index "\n";
    print $index "<h3>Directories / Files:</h3>\n";

    foreach my $directory (sort keys %directories)
    {
        print $index "<p>" . substr($directory, 0, length($directory) - 1) . "</p>\n";
        print $index "<ul>\n";

        foreach my $file (@{$files{$directory}})
        {
            next if $file =~ /index.html/;
            print $index "\t<li><a href=\"" . $file . "\">" . $file . "</a></li>\n";
        }

        print $index "</ul>\n";
        print $index "\n";
    }

    print $index "\n";
    print $index "</body>\n";
    print $index "</html>\n";

    close($index);
}
else
{
    opendir(DIR, ".");

    while(defined(my $item = readdir(DIR)))
    {
        if(-d $item)
        {
            $directories{$item}++;
            next;
        }

        if(defined($opt_a))
        {
            $files{$item}++;
        }
        else
        {
            my($name, $path, $extension) = fileparse($item, @extensions);

            if($extension)
            {
                $files{$item}++;
            }
        }
    }

    delete($files{"index.html"});

    closedir(DIR);

    my $index = IO::File->new("index.html", ">") or croak "Unable to open \"index.html\: " . $OS_ERROR;

    print $index "<html>\n";
    print $index "<head>\n";
    print $index "<title>" . $title . "</title>\n";
    print $index "<link rel=\"stylesheet\" type=\"text/css\" href=\"default.css\"/>\n";
    print $index "</head>\n";
    print $index "<body>\n";
    print $index "\n";
    print $index "<h3>Directories:</h3>\n";
    print $index "<ul>\n";

    foreach my $directory (sort keys %directories)
    {
        print $index "\t<li><a href=\"" . $directory . "\">" . $directory . "</a></li>\n";
    }

    print $index "</ul>\n";
    print $index "\n";
    print $index "<br>\n";
    print $index "\n";
    print $index "<h3>Files:</h3>\n";
    print $index "<ul>\n";

    foreach my $file (sort keys %files)
    {
        print $index "\t<li><a href=\"" . $file . "\">" . $file . "</a></li>\n";
    }

    print $index "</ul>\n";
    print $index "\n";
    print $index "</body>\n";
    print $index "</html>\n";

    close($index);
}

print "\tindex.html created\.\n";


=pod

=head4 process_tree()

Process a directory tree (if the script is called recursively).  

=cut
sub process_tree
{
    my $item = $File::Find::name;

    if(-d $item)
    {
        $directories{$item . "\/"}++;
    }
    else
    {
        my($name, $path, $extension) = fileparse($item, @extensions);

        if(defined($opt_a))
        {
            $directories{$item}++;

            push(@{$files{$path}}, $item);
        }
        elsif(defined($extension) && length($extension) > 0)
        {
            $directories{$path}++;

            push(@{$files{$path}}, $item);
        }
    }
}


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub syntax
{
    print "\n\tsyntax: makeindex [-t \"<title>\"] [-r] [-e \"<extensions>\"] \n";
    print "\n";
    print "\toptions:\n";
    print "\t          -t <title> (be sure it's in quotes)\n";
    print "\t          -r recursive (default is pwd only)\n";
    print "\t          -e file extensions (in quotes, default is \"html\")\n";
    print "\t          -a all files, disregard extensions\n";
    print "\n";
    print "\texample: makeindex -t \"MyIndex\" -e \"html txt\"\n";
    print "\n";

    exit(-1);
}


=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
