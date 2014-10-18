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

my $event = { 'price' => 10 };
$keen->publish("testing", $event);

cmp_ok($adapter->last_body, 'eq', encode_json($event));
cmp_ok($adapter->last_method, 'eq', 'POST');
cmp_ok($adapter->last_key, 'eq', $ENV{'KEEN_WRITE_KEY'});
cmp_ok($adapter->last_url, 'eq', '/projects/projectid/events/testing');

done_testing();
