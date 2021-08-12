package StKateNLP;

use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use Utilities;

my $util = new Utilities();

sub new
{
    my $package = shift;

    my $dn = {
        temp => '',
    };

    bless $dn, $package;
    return $dn;
}

sub count_review_terms
{
    my $self      = shift;
    my $review_id = shift;
    my $string    = shift;
    my $hash_ref  = shift;

    chomp $string;
    $string = $self->cleanse($string);
    $string = $util->tighten($string);
    return unless $util->test_var($string);

    my @terms = split /\s+/, $string;

    foreach my $term (@terms)
    {
        next if $self->is_number($term);

        $hash_ref->{($review_id . "|" . $term)}++;
    }
}

sub cleanse
{
    my $self   = shift;
    my $string = shift;

    $string =~ s/\(//g;
    $string =~ s/\)//g;
    $string =~ s/\[//g;
    $string =~ s/\]//g;
    $string =~ s/\{//g;
    $string =~ s/\}//g;

    $string =~ s/\.//g;
    $string =~ s/\?//g;
    $string =~ s/\%//g;
    $string =~ s/\&//g;
    $string =~ s/\$//g;
    $string =~ s/\*//g;
    $string =~ s/\_//g;
    $string =~ s/\///g;
    $string =~ s/\\//g;
    $string =~ s/\|//g;
    $string =~ s/\+//g;
    $string =~ s/\@//g;
    $string =~ s/\#//g;
    $string =~ s/\<//g;
    $string =~ s/\>//g;

    $string =~ s/!//g;
    $string =~ s/,//g;
    $string =~ s/-//g;
    $string =~ s/://g;
    $string =~ s/;//g;
    $string =~ s/=//g;
    $string =~ s/'//g;
    $string =~ s/`//g;
    $string =~ s/"//g;

    return lc $string;
}

sub is_number
{
    my $self   = shift;
    my $string = shift;

    return $string =~ /[0-9]/ && $string !~ /[A-Za-z]/;
    # return $string =~ /[0-9]/;
}

1;
