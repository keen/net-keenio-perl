use Test::More;
use JSON::MaybeXS;
use WWW::KeenIO;

use lib 't/lib';

use TestAdapter;

$ENV{'KEEN_PROJECT_ID'} = 'projectid';
$ENV{'KEEN_MASTER_KEY'} = 'master';
$ENV{'KEEN_READ_KEY'} = 'read';
$ENV{'KEEN_WRITE_KEY'} = 'write';

my $adapter = new TestAdapter();
my $keen = new WWW::KeenIO(http_adapter => $adapter);

$keen->count("testing");

cmp_ok($adapter->last_key, 'eq', $ENV{'KEEN_READ_KEY'});
cmp_ok($adapter->last_req->uri->as_string, 'eq', 'https://api.keen.io/3.0/projects/projectid/queries/count');
cmp_ok($adapter->last_req->method, 'eq', 'POST');
cmp_ok($adapter->last_req->content, 'eq', 'event_collection=testing');

done_testing();
