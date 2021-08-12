package Utilities;
#
# Name: Utilities.pm
# Date: 24 February, 2009
# Author: David McKoskey
# Purpose: miscellaneous functions used in numerous scripts

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: Utilities.pm

=item *

Author: David McKoskey

=back



=head2 Purpose

Miscellaneous functions used in numerous scripts



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
        <td>February 24, 2009</td>
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
use File::Basename;
use Scalar::Util qw(openhandle);

my %random_numbers;
my %indexes;


=pod

=head4 ()

Package constructor.  Follows the Java object construction syntax.  

=cut
sub new
{
	my $package = shift;

	my $m = { 
                temp => '',
            };

	bless  $m, $package;
	return $m;
}


=pod

=head4 test_var ()

Test a variable to see if it's been defined() and has length greater than 0.

=cut
sub test_var
{
    my $self = shift;
    my $var  = shift;

    if(defined($var) && length($var) > 0)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}


=pod

=head4 trim ()

Trim whitespace from a string variable.

=cut
sub trim
{
    my $self = shift;
	my $string = shift;

    return unless defined($string);
    return if length($string) == 0;

	$string =~ s/^\s+//g;
	$string =~ s/\s+$//g;

	return $string;
}


=pod

=head4 tighten ()

Trim whitespace from a string variable, and change all internal white space to single spaces.

=cut
sub tighten
{
    my $self = shift;
	my $string = shift;

    return unless $self->test_var($string);

    my $return_string = $self->trim($string);

    while($return_string =~ /\n/) { $return_string =~ s/\n/ /g; }

    while($return_string =~ /\t/) { $return_string =~ s/\t/ /g; }

    while($return_string =~ /  /) { $return_string =~ s/  / /g; }

	return $return_string;
}


=pod

=head4 ucfirst_all ()

Change all elements in a space delimited string to upper case initial.  

=cut
sub ucfirst_all
{
    my $self = shift;
	my $string = shift;

    return unless $self->test_var($string);

    my $return_string = "";

    my @pieces = split /\s+/, $string;

    for(my $i = 0; $i <= $#pieces; $i++)
    {
        $return_string .= ucfirst $pieces[$i];

        if($i < $#pieces)
        {
            $return_string .= " ";
        }
    }

    $return_string = $self->tighten($return_string);

    return $return_string;
}


=pod

=head4 crunch ()

Remove all whitespace from a string.  

=cut
sub crunch
{
    my $self = shift;
	my $string = shift;

    return unless $self->test_var($string);

    my $return_string = $self->trim($string);

    while($return_string =~ /\n/) { $return_string =~ s/\n//g; }

    while($return_string =~ /\t/) { $return_string =~ s/\t//g; }

    while($return_string =~ / /) { $return_string =~ s/ //g; }

	return $return_string;
}


=pod

=head4 get_print_date ()

Get the current date in a nice, printable format.  

=cut
sub get_print_date
{
    my $self = shift;
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);

	$year += 1900;

	my $printday = qw(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)[(localtime)[6]];
	my $printmonth = qw(January February March April May June July August September October November December)[(localtime)[4]];

	return $printday . " " . $printmonth . " " . $mday . ", " . $year;

}


=pod

=head4 get_short_date ()

Get a short version of the current date: MM-DD-YYYY

=cut
sub get_short_date
{
    my $self = shift;
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);

	my $month = $mon + 1;
	$year += 1900;

	if(length($mday)  == 1) { $mday   = "0" . $mday; }
	if(length($month) == 1) { $month = "0" . $month; }

	return ($month . "-" . $mday . "-" . $year);
}


=pod

=head4 get_file_timestamp ()

Get a version of the current date usable for files: MMDDYYYYHHMiSS

=cut
sub get_file_timestamp
{
    my $self = shift;
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);

	my $month = $mon + 1;
	$year += 1900;

	if(length($sec)   == 1) { $sec    = "0" . $sec;   }
	if(length($min)   == 1) { $min    = "0" . $min;   }
	if(length($hour)  == 1) { $hour   = "0" . $hour;  }
	if(length($mday)  == 1) { $mday   = "0" . $mday;  }
	if(length($month) == 1) { $month  = "0" . $month; }

	return ($year . $month . $mday . $hour . $min . $sec);
}


=pod

=head4 get_file_date ()

Get a version of the current date usable for files: MMDDYYYY

=cut
sub get_file_date
{
    my $self = shift;
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);

	my $month = $mon + 1;
	$year += 1900;

	if(length($mday)  == 1) { $mday   = "0" . $mday; }
	if(length($month) == 1) { $month = "0" . $month; }

	return ($year . $month . $mday);
}


=pod

=head4 get_title ()

Change a file name string into a file title with the same words.  

=cut
sub get_title
{
    my $self = shift;
	my $filename = shift;
	my $title = "";

	$filename =~ s/\.tex//g;
	$filename =~ s/\.txt//g;
	$filename =~ s/\.xml//g;
	$filename =~ s/\.html//g;
	$filename =~ s/_/ /g;
	$filename =~ s/-/ /g;

	my @pieces = split /\s+/, $filename;

	foreach my $piece (@pieces)
    {
        $title .= ucfirst($piece);
        $title .= " ";
    }

	return $self->trim($title);
}


=pod

=head4 get_title ()

Change a file name string into a file title with the same words.  

=cut
sub get_label
{
    my $self = shift;
	my $filename = shift;
	my $label = "";

	$filename =~ s/\.tex//g;
	$filename =~ s/\.txt//g;
	$filename =~ s/\.xml//g;
	$filename =~ s/\.html//g;
	$filename =~ s/_/ /g;

	my @pieces = split /\s+/, $filename;

	foreach my $piece (@pieces) { $label .= ucfirst($piece); }

	return $label;
}


=pod

=head4 ()

Get a list of input files from the @ARGV array.  

=cut
sub get_infiles_from_argv
{
    my $self = shift;
    my $argv_ref = shift;

    my @infilenames = ();

    foreach my $path (@{$argv_ref})
    {
        next unless defined ($path);
        next unless length($path) > 0; # skip blank lines

        if($path =~ /\*/)
        {
            my @paths = glob($path); # @ARGV was not expanded (Win32)

            foreach my $p (@paths) { if(-f $p) { push(@infilenames, $p); } }
        }
        else { if(-f $path) { push(@infilenames, $path); } }
    }

    return \@infilenames;
}


=pod

=head4 ()

Get an array of input files from a text file (list).

=cut
sub get_infiles_from_list
{
    my $self = shift;
    my $listfilename = shift;

    my @infilenames = ();

    my $listfile  = IO::File->new($listfilename,  '<') or croak "Unable to open \""  . $listfilename . "\": " . $OS_ERROR;

    while(my $path = <$listfile>)
    {
        next unless defined ($path);

        chomp($path);

        next unless length($path) > 0;      # skip blank lines
        next if substr($path, 0, 1) eq '#'; # skip commented out lines
        next unless -f $path;               # skip files we can't find

        push(@infilenames, $path);
    }

    close $listfile;

    return \@infilenames;
}


=pod

=head4 ()

Print an HTML table to an open output file handle.  Data source is an array of arrays.  

=cut
sub html_table
{
    my $self = shift;
    my $array_ref = shift;
    my $output_handle = shift;

    print $output_handle "<table>\n";

    foreach my $line_ref (@{$array_ref})
    {
        print $output_handle "\t<tr>\n";

        foreach my $field (@{$line_ref})
        {
            print $output_handle "\t\t<td>" . $field . "</td>\n";
        }

        print $output_handle "\t</tr>\n";
    }

    print $output_handle "</table>\n";
}


=pod

=head4 ()

Pause the execution of a console-run script and await input (a carriage return).  

=cut
sub pause
{
    my $self = shift;
    my $message = shift;

    return unless is_interactive();

    $message = "" unless defined($message);
    $message = "" unless length($message) > 0;

    if(length($message) > 0) { print $message . "\n"; }

    chomp(my $input = <STDIN>);
}


=pod

=head4 ()

Generate a random number.  Keeps track of which random numbers have already been given.  

=cut
sub random_number
{
    my $self = shift;

    my $range = 100;

    my $random_number = 0;
   
    do
    {
        $random_number = int(rand($range));
    }
    while($random_numbers{$random_number});

    $random_numbers{$random_number} = 1;

    return $random_number;
}


=pod

=head4 ()

Get an index number (unsigned integer).  Keeps trakc of the indexes already given.  

=cut
sub get_index
{
    my $self = shift;

    my $index = 0;

    do
    {
        $index++;
    }
    while($indexes{$index});

    $indexes{$index} = 1;

    return $index;
}


=pod

=head4 ()

Get the size of an array.  

=cut
sub get_array_size
{
    my $self = shift;
    my $array_ref = shift;

    my $size = 0;

    foreach my $item (@{$array_ref})
    {
        $size++;
    }

    return $size;
}


sub is_in_array
{
    my $self = shift;
    my $string = shift;
    my $array_ref = shift;

    foreach my $item (@{$array_ref})
    {
        return 1 if $item eq $string;
    }

    return 0;
}


=pod

=head4 ()

Get the size of a hash table.  

=cut
sub get_hash_size
{
    my $self = shift;
    my $hash_ref = shift;

    my $size = 0;

    foreach my $item (%{$hash_ref})
    {
        $size++;
    }

    return $size;
}


=pod

=head4 ()

Right-pad a string.

=cut
sub rpad
{
    my $self = shift;
    my $string = shift;
    my $pad_length = shift;
    my $pad_char = shift;  # optional

    if($self->test_var($string))
    {
        if($self->test_var($pad_length))
        {
            return $string if length($string) >= $pad_length;

            return $string if $pad_length =~ /[A-Za-z]/;
        }
        else { return $string; }
    }
    else { return ""; }

    if($self->test_var($pad_char))
        { $pad_char = substr($pad_char, 0, 1); }
    else
        { $pad_char = " "; }

    for(my $i = length($string); $i < $pad_length; $i++) { $string .= $pad_char; }

    return $string;
}


=pod

=head4 ()

Left-pad a string.

=cut
sub lpad
{
    my $self = shift;
    my $string = shift;
    my $pad_length = shift;
    my $pad_char = shift;  # optional

    if($self->test_var($string))
    {
        if($self->test_var($pad_length))
        {
            return $string if length($string) >= $pad_length;

            return $string if $pad_length =~ /[A-Za-z]/;
        }
        else { return $string; }
    }
    else { return ""; }

    if($self->test_var($pad_char))
        { $pad_char = substr($pad_char, 0, 1); }
    else
        { $pad_char = " "; }

    for(my $i = length($string); $i < $pad_length; $i++) { $string = $pad_char . $string; }

    return $string;
}


=pod

=head4 ()

Determine if the current application is a console application and can therefore be used interactively (on the command line).  Taken from _Perl Best Practices_ by Damian Conway (O'Reilly Press).  

=cut
sub is_interactive
{
    my $self = shift;

    # Not interactive if output is not to terminal...
    return 0 unless -t *STDOUT;

    # if *ARGV is opened, we're interactive if...
    if(openhandle *ARGV)
    {
        # ... it's currently opened to the magic '-' file
        return -t *STDIN if $ARGV eq '-';

        # ... it's at end-of-file and the next file is the magic '-' file
        return @ARGV > 0 && $ARGV[0] eq '-' && -t *STDIN if eof *ARGV;

        # ... it's directly attached to the terminal
        return -t *ARGV;
    }

    # If *ARGV isn't opened, it will be interactive if *STDIN is attached
    # to a terminal and either there are no files specified on the command line
    # or if there are one or more files and the first is the magic '-' file.
    return -t *STDIN && (@ARGV == 0 || $ARGV[0] eq '-');
}


=pod

=head4 ()

Write a string to a specified file name.

=cut
sub write_file
{
    my $self         = shift;
    my $outfilename  = shift;
    my $outputstring = shift;

    my $outfile = IO::File->new($outfilename, '>') or croak "Unable to write \"" . $outfilename . "\": " . $OS_ERROR;
    print $outfile $outputstring;
    close $outfile;
}

1;

=pod

=begin html

</blockquote>

=end html

=cut

#
# end package
#
