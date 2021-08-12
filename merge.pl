#!/usr/bin/perl
#
# Name: merge.pl
# Date: 8 June, 2011
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: merge.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Merge the contents of two directories.  



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
        <td>June 8, 2011</td>
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

use Getopt::Long;
use File::Copy;
use File::Basename;

my $verbose = undef;
my $target_dir = undef;

my @extensions = qw(.txt .xml .java .c .cpp);

GetOptions
(
    'v' => \$verbose,
    't=s' => \$target_dir,
);

unless(defined($target_dir))
{
    syntax();
    exit -1;
}

unless(-d $target_dir)
{
    print "Target directory \"" . $target_dir . "\" does not exist.\n";
}

if(defined($verbose))
{
    print "Target Directory: \"" . $target_dir . "\"\n";
    print "Verbose mode ON\n";
    print "\n";
}



my @sourcefilenames = glob($ARGV[0]);

foreach my $sourcefilename (@sourcefilenames)
{
    my ($title, $path, $extension) = fileparse($sourcefilename, @extensions);

    my $targetfilename = $target_dir . "\\" . $title . $extension;

    if(defined($verbose))
    {
        print "Verifying a merge for \"" . $sourcefilename . "\" to \"" . $targetfilename . "\"...\n";
    }

    if(-e $targetfilename)
    {
        if(defined($verbose))
        {
            print "\"" . $targetfilename . "\" already exists, skipping.\n";
        }
    }
    else
    {
        if(defined($verbose))
        {
            print "\"" . $targetfilename . "\" does not exist, proceeding with copy.\n";
        }

        my $ret = copy($sourcefilename, $targetfilename);

        if(defined($verbose))
        {
            if($ret > 0)
            {
                print "Copying \"" . $sourcefilename . "\" to \"" . $targetfilename . "\" succeeded.\n";
            }
            else
            {
                print "ERROR: copying \"" . $sourcefilename . "\" to \"" . $targetfilename . "\" failed.\n";
            }

            print "\n";
        }
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
    print "syntax: merge [-v] -t <target> <source>";
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
