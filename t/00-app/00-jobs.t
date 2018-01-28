#!perl

use strict;
use warnings;

use Test::Most;
use ScrapingHub::API::Client::App::Jobs;
use JSON qw/decode_json/;

my $api_key = $ENV{SH_API_KEY};
my $test_live = $ENV{TEST_LIVE};
my $api_url = 'https://app.scrapinghub.com/api';

if (!$api_key || !$api_url) {
    plan skip_all => "Missing API key, so we are skipping tests...";
}

my @projects = (
    {
        id     => '__PROJECT__',
        spider => '__SPIDER__'
    }
);

dies_ok { ScrapingHub::API::Client::App::Jobs->new() } "Dies on missing required attributes.";

foreach my $method (map{ chomp $_; $_; } <DATA>) {
    can_ok('ScrapingHub::API::Client::App::Jobs', $method);
}

my $sh = ScrapingHub::API::Client::App::Jobs->new({ api_key => $api_key, api_url => $api_url });

ok defined($sh->api_key), "api_key is defined (required parameter).";
ok defined($sh->api_url), "api_url is defined (required parameters).";

dies_ok { $sh->schedule_run() } "Dies on missing required parameters.";
dies_ok { $sh->get_job_list() } "Dies on missing required parameters.";
dies_ok { $sh->update_job } "Dies on missing required parameters.";
dies_ok { $sh->delete_job() } "Dies on missing required parameters.";
dies_ok { $sh->stop_job() } "Dies on missing required parameters.";

subtest 'schedule_run' => sub {

    if (!$test_live) {
        plan skip_all => "Missing test live environment variable... skipping live API queries of schedule_run.";
    }

    my $job = $sh->schedule_run({ project => $projects[0]->{id}, spider => $projects[0]->{spider} });
    $job = decode_json($job);

    ok( $sh->last_query_response->code == 200, "200 OK status returned in the response" );
    ok( $job->{status} eq 'ok', "Successful status returned in the response" );
    ok( defined($job->{jobid}), "We have our job ID of our scheduled run in the response" );
};

subtest 'get_job_list' => sub {
    
    if (!$test_live) {
        plan skip_all => "Missing test live environment variable... skipping live API queries of get_job_list.";
    }

    my $jobs = $sh->get_job_list({ project => $projects[0]->{id} });
    $jobs = decode_json($jobs);

    ok( $sh->last_query_response->code == 200, "200 OK status returned in the response" );
    ok( $jobs->{status} eq 'ok', "Successful status returned in the response" );
    ok( defined($jobs->{jobs}), "We have our job list in the response" );
};

subtest 'update_job' => sub {

    if (!$test_live) {
        plan skip_all => "Missing test live environment variable... skipping live API queries of update_job.";
    }

    my $job = $sh->schedule_run({ project => $projects[0]->{id}, spider => $projects[0]->{spider} });
    $job = decode_json($job);

    my $job_id = $job->{jobid};

    my $updated = $sh->update_job({ job_id => $job_id, project => $projects[0]->{id}, add_tag => 'fancy_tag' });
    $updated = decode_json($updated);

    ok( $sh->last_query_response->code == 200, "200 OK status returned in the response" );
    ok( $updated->{status} eq 'ok', "Successful status returned in the response" );
};

subtest 'delete_job' => sub {

    if (!$test_live) {
        plan skip_all => "Missing test live environment variable... skipping live API queries of delete_job.";
    }

    my $jobs = $sh->get_job_list({ project => $projects[0]->{id} });
    $jobs = decode_json($jobs);

    my $job_id;
    foreach my $job (@{$jobs->{jobs}}) {
        if ($job->{state} ne 'running') { # Can't delete a running job.
            $job_id = $job->{id};
            last;
        }
    }

    my $deleted = $sh->delete_job({ job_id => $job_id, project => $projects[0]->{id} });
    $deleted = decode_json($deleted);

    SKIP: {
        skip "No non-running jobs for the project specified, so skipping...", 2, unless ($job_id);
        ok( $sh->last_query_response->code == 200, "200 OK status returned in the response" );
        ok( $deleted->{status} eq 'ok', "Successful status returned in the response" );
    }
};

subtest 'stop_job' => sub {

    if (!$test_live) {
        plan skip_all => "Missing test live environment variable... skipping live API queries of stop_job.";
    }

    my $job = $sh->schedule_run({ project => $projects[0]->{id}, spider => $projects[0]->{spider} });
    $job = decode_json($job);

    my $job_id = $job->{jobid};

    my $stopped = $sh->stop_job({ job_id => $job_id, project => $projects[0]->{id} });
    $stopped = decode_json($stopped);

    ok( $sh->last_query_response->code == 200, "200 OK status returned in the response" );
    ok( $stopped->{status} eq 'ok', "Successful status returned in the response" );
};

done_testing();

__DATA__
api_key
api_url
ua
ua_headers
last_query_response
last_query_error
query
schedule_run
get_job_list
update_job
delete_job
stop_job
