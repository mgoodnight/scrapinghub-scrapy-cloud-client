#!perl

use strict;
use warnings;

use Test::Most;
use JSON qw/decode_json/;
use ScrapingHub::API::Client::Storage::Items;

my $api_key = $ENV{SH_API_KEY};
my $test_live = $ENV{TEST_LIVE};
my $api_url = 'https://storage.scrapinghub.com';

my $project = '__PROJECT__';
my $spider_num = '__SPIDER__';
my $job_num = '__JOB_NO__';

if (!$api_key) {
    plan skip_all => "Missing API key, so we are skipping tests...";
}

dies_ok { ScrapingHub::API::Client::Storage::Items->new() } "Dies on missing required attributes.";

foreach my $method (map{ chomp $_; $_; } <DATA>) {
    can_ok('ScrapingHub::API::Client::Storage::Items', $method);
}

my $sh = ScrapingHub::API::Client::Storage::Items->new({ api_key => $api_key, api_url => $api_url });

ok defined($sh->api_key), "api_key is defined (required parameter).";

dies_ok { $sh->get_items } "Dies on missing required parameters.";
dies_ok { $sh->get_job_item_stats } "Dies on missing required parameters.";

subtest "get_items" => sub {

    if (!$test_live) {
        plan skip_all => "Missing test live environment variable... skipping live API queries of get_items.";
    }

    my $job = "$project/$spider_num/$job_num";
    my $items = $sh->get_items({ job => $job });
    $items = decode_json($items);
    explain $items;

    ok( $sh->last_query_response->code == 200, "200 OK status returned in the response" );
    ok( ref($items) eq 'ARRAY', "Type ARRAY was returned within the request" );
};

subtest 'get_job_item_stats' => sub {

    if (!$test_live) {
            plan skip_all => "Missing test live environment variable... skipping live API queries of get_job_item_stats.";
    }

    my $job = "$project/$spider_num/$job_num";
    my $stats = $sh->get_job_item_stats({ job => $job });
    $stats = decode_json($stats);
    explain $stats;

    ok( $sh->last_query_response->code == 200, "200 OK status returned in the response" );
    ok( ref($stats) eq 'HASH', "Type HASH was returned within the request" );
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
get_items
get_job_item_stats
