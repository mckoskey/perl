#!/usr/bin/perl
#
# Name: make_pod.pl
# Date: 
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: make_pod.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Create POD documentation for all Perl scripts, HTML format.  



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
        <td>June 8, 1998</td>
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

=cut


use strict;
use warnings;

use Carp;
use English;
use IO::File;
use File::Basename;

# my @filenames = @ARGV;
  my @filenames = glob($ARGV[0]);

my @extensions = qw(.pl);
my $directory = "./html";

if( -d $directory )
{
    opendir(DIR, $directory);

    while(defined(my $file = readdir(DIR)))
    {
        next if -d ($directory . "/" . $file);
        # print "Removing \"" . $directory . "/" . $file . "\"\n";
        unlink ($directory . "/" . $file);
    }

    closedir(DIR);

    # print "Removing \"" . $directory . "\"\n";
    rmdir $directory;
}

mkdir $directory;

foreach my $filename (@filenames)
{
    my($name, $path, $extension) = fileparse($filename, @extensions);

    my $htmlname = $name . ".html";

    my $command = "perldoc -d " . $directory . "/" . $htmlname . " -o HTML " . $filename;

    my $ret = system($command);
}


=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
