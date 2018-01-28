package ScrapingHub::API::Client;

# ABSTRACT: Client for the ScrapingHub Scrapy Cloud API

use strict;
use warnings;

use Moo;
use LWP::UserAgent;
use Carp qw/confess/;
use URI::Escape;

has ['api_key', 'api_url'] => (
    is       => 'ro',
    required => 1
);

has ua => (
    is      => 'ro',
    builder => sub {
        return LWP::UserAgent->new(
            timeout  => 300,
            ssl_opts => {
                verify_hostname => 1
            }
        );
    }
);

has ua_headers => (
    is      => 'rw',
    isa     => sub {
        die "ua_headers must be type ARRAY!" unless ref($_[0]) eq 'ARRAY';
    },
    default => sub {
        return [ 'Accept' => 'application/json' ];
    }
);

has last_query_response => ( is => 'rwp' );

has last_query_error => ( is => 'rwp' );

sub query {
    my $self = shift;
    my ($method, $url, $params) = @_;
    $method = lc($method);

    unless ( $self->ua->can($method) ) {
        confess "No method '$method' within the declared user agent.";
    }
    
    $url .= '?apikey=' . $self->api_key;

    if (keys %$params) {
        if ($method eq 'get') {
            $url .= '&' . join('&', map {
                "$_=" . URI::Escape::uri_escape_utf8($params->{$_})
            } sort keys %$params); # Sort for readability
        }
    }
    
    my $response = $self->ua->$method($url, $self->ua_headers, $params); # $params will be garbage collected if $method is not 'post' or 'get'.  
    $self->_set_last_query_response($response);

    my $content_decoded = $response->decoded_content;
    $self->_set_last_query_error($content_decoded) if !$response->is_success;

    return $content_decoded;
}

1;

=head1 NAME

ScrapingHub Scrapy Cloud API Client Interface

=head1 SYNOPSIS

use ScrapingHub::API::Client;

my $client = ScrapingHub::API::Client->new({ api_key => "some_api_key", api_url => 'api.example.org });
my $response = $client->query('GET', 'http://example.org', { some_key => 'some_value' });

=head1 DESCRIPTION

This is the parent class for the APIs that fall under the Scrapy Cloud API suite.  Not all APIs are implemented, but will be in future releases.

=head2 APIs implemented

=head3 App

Jobs

=head3 Storage

Items

=head1 ATTRIBUTES

=over

=item api_key
=item api_url
=item ua
=item ua_headers
=item last_query_response
=item last_query_error

=back

=head1 METHODS

=head2 query

Queries the URL provided with the specified method and parameters.

C<< my $response = $client->query('GET', $url, $params); >>

=cut
