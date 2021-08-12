#!/usr/bin/perl
#
# Name: synchronize.pl
# Date: 9 June, 2011
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: synchronize.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Synchronizes the contents of two directories.  



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
        <td>June 9, 2011</td>
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
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use File::Find;
use File::Path;
use File::Copy;
use Getopt::Std;
use vars qw($opt_v);
getopts('v');

if($#ARGV < 1)
{
    syntax();
    exit(-1);
}

my $dir1 = shift @ARGV;
my $dir2 = shift @ARGV;

my $verbose = 0;
if($opt_v) { $verbose = 1; }


print "Comparing files in directory \"" . $dir1. "\" with files in directory \"" . $dir2 . "\"\n";

find(\&findFiles, $dir1);

sub findFiles
{
    my $file1 = $File::Find::name;

    if( -d $file1) { return; }

    my $file2 = $file1;
       $file2 =~ s/$dir1/$dir2/;

    # print "Comparing \"" . $file1 . "\" and \"" . $file2 . "\"\n";
    # return;

    if(! -f $file2)
    {
        if($verbose)
        {
            print "\"" . $file1 . "\" does not have a counterpart \"" . $file2 . "\" (does not exist), skipping...\n";
        }

        return;
    }

    my @stats_file1 = stat $file1;
    my @stats_file2 = stat $file2;

    my $acc_time1 = $stats_file1[8];
    my $acc_time2 = $stats_file2[8];

    my $mod_time1 = $stats_file1[9];
    my $mod_time2 = $stats_file2[9];

    # print "times: " . $mod_time1 . " " . $mod_time2 . " " . $acc_time1 . " " . $acc_time2 . "\n";
    # print "diffs: " . abs($mod_time1 - $mod_time2) . " " . abs($acc_time1 - $acc_time2) . "\n";

    if(abs($mod_time1 - $mod_time2) < 1 && abs($acc_time1 - $acc_time2) < 1 && $verbose)
    {
        print "\"" . $file1 . "\" and \"" . $file2 . "\" are functionally identical, skipping.\n";
        return;
    }

    if($mod_time1 eq $mod_time2)
    {
        if($acc_time1 > $acc_time2)
        {
            if($verbose)
                { print "\"" . $file1 . "\" access time > \"" . $file2 . "\" mod time, copying \"" . $file1 . "\" to \"" . $file2 ."\"\n"; }

            do_copy($file1, $file2);
        }
        else # $acc_time1 > $acc_time2
        {
            if($verbose)
                { print "\"" . $file1 . "\" access time < \"" . $file2 . "\" mod time, copying \"" . $file2 . "\" to \"" . $file1 ."\"\n"; }

            do_copy($file2, $file1);
        }
    }
    else
    {
        if($mod_time1 > $mod_time2)
        {
            if($verbose)
                { print "\"" . $file1 . "\" modification time > \"" . $file2 . "\" mod time, copying \"" . $file1 . "\" to \"" . $file2 ."\"\n"; }

            do_copy($file1, $file2);
        }
        else # $mod_time1 > $mod_time2
        {
            if($verbose)
                { print "\"" . $file1 . "\" modification time > \"" . $file2 . "\" mod time, copying \"" . $file1 . "\" to \"" . $file2 ."\"\n"; }

            do_copy($file2, $file1);
        }
    }
}


=pod

=head4 do_copy()

Copy a file from one location to another.

=cut
sub do_copy 
{
    my $file1 = shift;
    my $file2 = shift;

    my $ret = copy $file1, $file2;
    
    if($ret <= 0)
    {
        print "Unable to copy \"" . $file1 . "\" to \"" . $file2 . "\"\n";
    }
}


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub syntax
{
    print "\n";
    print "    ";
    print "Syntax: synchronize [-v] <dir_1> <dir_2>";
    print "\n";
}


=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
