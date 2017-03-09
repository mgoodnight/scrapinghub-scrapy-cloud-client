package ScrapingHub::API::Utils;

use Exporter;
use Carp qw/confess/;

@EXPORT_OK = qw/flag_missing_params/;
@ISA = qw(Exporter);

sub flag_missing_params {
    my ($params, @required_fields) = @_;

    foreach my $required (@required_fields) {
        confess "Missing required parameter: $required" if (!defined($params->{$required}));
    }

    return 1;
}

1;
