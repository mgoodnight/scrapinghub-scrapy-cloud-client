package ScrapingHub::API::Client::Storage::Items;

use Moo;
    extends 'ScrapingHub::API::Client';
use URI::Escape;
use ScrapingHub::API::Utils qw/flag_missing_params/;

sub get_items {
    my ($self, $args) = @_;

    flag_missing_params($args, qw/job/);

    my $job= $args->{job} and delete $args->{job};
    my $field = $args->{field} and delete $args->{field};

    my $url = $self->api_url . '/items/' . $job;
    $url .= '/' . URI::Escape::uri_escape_utf8($field) if ($field);

    return $self->query('GET', $url, $args);
}

sub get_job_item_stats {
    my ($self, $args) = @_;

    flag_missing_params($args, qw/job/);

    my $project = $args->{project} and delete $args->{project};
    my $spider_id = $args->{spider_id} and delete $args->{spider_id};
    my $job = $args->{job} and delete $args->{job};

    my $url = $self->api_url . '/items/' . $job . '/stats';

    return $self->query('GET', $url, $args);
}

1;

=head1 NAME

ScrapingHub Items API client interface

=head1 SYNOPSIS

my $sh_jobs = ScrapingHub::API::Client::App::Items;
my $items = $sh_jobs->get_items({ job => '123456/56/78' });

=head1 DESCRIPTION

Client interface for the Jobs API that falls under the ScapingHub's Scrapy API suite.

=head1 METHODS

=head2 get_items

Get the items that were scraped for a particular job.  

C<< my $items = $sh_jobs->get_items({ job => '123456/56/78' }); >>

=head2 get_job_item_stats

Get the stats for the items scraped for a particular job.

C<< my $stats = $sh_jobs->get_job_item_stats({ job => '123456/56/78' }); >>

=cut

