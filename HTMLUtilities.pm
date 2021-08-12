package HTMLUtilities;
#
# Name: HTMLUtilities.pm
# Date: 28 June, 2011
# Author: David McKoskey
# Purpose: miscellaneous functions used in numerous scripts

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: HTMLUtilities.pm

=item *

Author: David McKoskey

=back



=head2 Purpose

Miscellaneous functions used in creating or fixing HTML / XHTML / XML pages.  



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
        <td>June 28, 2011</td>
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

=head4 clean_up_string ()

Clean up Win32 1251 character codes: smart quotes, em dashes, en dashes, ellipsis, etc.  Turn them into valid HTML.  

=cut
sub clean_up_string
{
    my $self = shift;
    my $string = shift;

    $string = $self->clean_up_ellipsis($string);

    $string = $self->clean_up_single_quotes($string);
    $string = $self->clean_up_smart_quotes($string);

    $string = $self->clean_up_centered_dot($string);

    $string = $self->clean_up_dashes($string);

    $string = $self->clean_up_space($string);

    return $string;
}


=pod

=head4 clean_up_ellipsis ()

Replace ellipsis octal character with HTML ellipsis

=cut
sub clean_up_ellipsis
{
    my $self = shift;
    my $string = shift;

    $string =~ s/\205/&hellip;/e;

    return $string;
}


=pod

=head4 clean_up_single_quotes ()

Replace octal single quotes with HTML equivalent.  

=cut
sub clean_up_single_quotes
{
    my $self = shift;
    my $string = shift;

    $string =~ s/\221/&lsquo;/e;
    $string =~ s/\222/&rsquo;/e;

    return $string;
}


=pod

=head4 clean_up_smart_quotes ()

Replace "smart" double-quotes with HTML equivalent.  

=cut
sub clean_up_smart_quotes
{
    my $self = shift;
    my $string = shift;

    $string =~ s/\223/&ldquo;/e;
    $string =~ s/\224/&rdquo;/e;

    return $string;
}


=pod

=head4 clean_up_centered_dot ()

Replace large centered dot with HTML bullet character.  

=cut
sub clean_up_centered_dot
{
    my $self = shift;
    my $string = shift;

    $string =~ s/\225/&bull;/e;

    return $string;
}


=pod

=head4 clean_up_dashes ()

Replace octal em dashes and en dashes with HTML equivalent.

=cut
sub clean_up_dashes
{
    my $self = shift;
    my $string = shift;

    $string =~ s/\226/&endash/e;
    $string =~ s/\227/&emdash/e;

    return $string;
}


=pod

=head4 clean_up_space ()

Replace no-break space with HTML equivalent.

=cut
sub clean_up_space
{
    my $self = shift;
    my $string = shift;

    $string =~ s/\240/&nbsp;/e;
    # $string =~ tr/\240/ /;

    return $string;
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
