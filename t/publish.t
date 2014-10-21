use Test::More;
use JSON::MaybeXS;
use Net::KeenIO;

use lib 't/lib';

use TestAdapter;

$ENV{'KEEN_PROJECT_ID'} = 'projectid';
$ENV{'KEEN_MASTER_KEY'} = 'master';
$ENV{'KEEN_READ_KEY'} = 'read';
$ENV{'KEEN_WRITE_KEY'} = 'write';

my $adapter = new TestAdapter();
my $keen = Net::KeenIO->new(http_adapter => $adapter);

my $event = { 'price' => 10 };
$keen->publish("testing", $event);

cmp_ok($adapter->last_key, 'eq', $ENV{'KEEN_WRITE_KEY'});
cmp_ok($adapter->last_req->uri->as_string, 'eq', 'https://api.keen.io/3.0/projects/projectid/events/testing');
cmp_ok($adapter->last_req->method, 'eq', 'POST');
cmp_ok($adapter->last_req->header('Content-Type'), 'eq', 'application/json');
cmp_ok($adapter->last_req->content, 'eq', encode_json($event));

done_testing();
