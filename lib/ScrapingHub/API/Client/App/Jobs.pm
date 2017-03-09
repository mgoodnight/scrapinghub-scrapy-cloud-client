package ScrapingHub::API::Client::App::Jobs;

use Moo;
    extends 'ScrapingHub::API::Client';
use Carp qw/confess/;
use ScrapingHub::API::Utils qw/flag_missing_params/;

sub schedule_run {
    my ($self, $args) = @_;

    flag_missing_params($args, qw/spider project/);

    my $url = $self->api_url . '/run.json';
    
    return $self->query('POST', $url, $args); 
}

sub get_job_list {
    my ($self, $args) = @_;

    flag_missing_params($args, qw/project/);

    my $url = $self->api_url . '/jobs/list.json';

    return $self->query('GET', $url, $args);
}

sub update_job {
    my ($self, $args) = @_;

    flag_missing_params($args, qw/job project/);

    my $url = $self->api_url . '/jobs/update.json';

    return $self->query('POST', $url, $args);
}

sub delete_job {
    my ($self, $args) = @_;

    flag_missing_params($args, qw/job project/);

    my $url = $self->api_url . '/jobs/delete.json';

    return $self->query('POST', $url, $args);
}

sub stop_job {
    my ($self, $args) = @_;

    flag_missing_params($args, qw/job project/);

    my $url = $self->api_url . '/jobs/stop.json';

    return $self->query('POST', $url, $args);
}

1;

=head1 NAME

ScrapingHub Jobs API client interface

=head1 SYNOPSIS

my $sh_jobs = ScrapingHub::API::Client::App::Jobs;
my $job = $sh_jobs->schedule_run({ project => '123456', spider => "my_fancy_spider" });

=head1 DESCRIPTION

Client interface for the Jobs API that falls under the ScapingHub's Scrapy API suite.

=head1 METHODS

=head2 schedule_run

Schedules a live run for a project's spider.

C<< my $job = $sh_jobs->schedule_run({ project => '123456', spider => "my_fancy_spider" }); >>

=head2 get_job_list

Get a list of all jobs for a project.

C<< my $jobs = $sh_jobs->get_job_list({ project => '123456' }); >>

=head2 update_job

Update a particular job for a project.  

C<< my $update = $sh_jobs->update_jobs({ project => '123456', job => '123456/12/34' }); >>

=head2 delete_job

Delete a job for a project.

C<< my $deleted = $sh_jobs->({ project => '123456', job => '123456/12/34' }); >>

=head2 stop_job

Stop a running job for a project.  

C<< my $stopped = $sh_jobs->({ project => '123456', job => '123456/12/34' }); >>

=cut
