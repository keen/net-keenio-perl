use Test::More;
use Test::Exception;
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

# COUNT

$keen->count('testing');

cmp_ok($adapter->last_key, 'eq', $ENV{'KEEN_READ_KEY'});
cmp_ok($adapter->last_req->uri->as_string, 'eq', 'https://api.keen.io/3.0/projects/projectid/queries/count');
cmp_ok($adapter->last_req->method, 'eq', 'POST');
cmp_ok($adapter->last_req->content, 'eq', 'event_collection=testing');
cmp_ok($adapter->last_req->header('Content-Type'), 'eq', 'application/x-www-form-urlencoded');

# SUM!

throws_ok { $keen->sum('testing') } qr/target_property/;

$keen->sum('testing', { target_property => 'price' });

cmp_ok($adapter->last_key, 'eq', $ENV{'KEEN_READ_KEY'});
cmp_ok($adapter->last_req->uri->as_string, 'eq', 'https://api.keen.io/3.0/projects/projectid/queries/sum');
cmp_ok($adapter->last_req->method, 'eq', 'POST');

like($adapter->last_req->content, qr/event_collection=testing/, 'sum has event_collection');
like($adapter->last_req->content, qr/target_property=price/, 'sum has target_property');
cmp_ok($adapter->last_req->header('Content-Type'), 'eq', 'application/x-www-form-urlencoded');

# MAXIMUM!

$keen->maximum('testing', { target_property => 'price' });

cmp_ok($adapter->last_key, 'eq', $ENV{'KEEN_READ_KEY'});
cmp_ok($adapter->last_req->uri->as_string, 'eq', 'https://api.keen.io/3.0/projects/projectid/queries/maximum');
cmp_ok($adapter->last_req->method, 'eq', 'POST');

like($adapter->last_req->content, qr/event_collection=testing/, 'maximum has event_collection');
like($adapter->last_req->content, qr/target_property=price/, 'maximum has target_property');
cmp_ok($adapter->last_req->header('Content-Type'), 'eq', 'application/x-www-form-urlencoded');

# MEDIAN!

$keen->median('testing', { target_property => 'price' });

cmp_ok($adapter->last_key, 'eq', $ENV{'KEEN_READ_KEY'});
cmp_ok($adapter->last_req->uri->as_string, 'eq', 'https://api.keen.io/3.0/projects/projectid/queries/median');
cmp_ok($adapter->last_req->method, 'eq', 'POST');

like($adapter->last_req->content, qr/event_collection=testing/, 'median has event_collection');
like($adapter->last_req->content, qr/target_property=price/, 'median has target_property');
cmp_ok($adapter->last_req->header('Content-Type'), 'eq', 'application/x-www-form-urlencoded');

# MINIMUM!

$keen->minimum('testing', { target_property => 'price' });

cmp_ok($adapter->last_key, 'eq', $ENV{'KEEN_READ_KEY'});
cmp_ok($adapter->last_req->uri->as_string, 'eq', 'https://api.keen.io/3.0/projects/projectid/queries/minimum');
cmp_ok($adapter->last_req->method, 'eq', 'POST');

like($adapter->last_req->content, qr/event_collection=testing/, 'minimum has event_collection');
like($adapter->last_req->content, qr/target_property=price/, 'minimum has target_property');
cmp_ok($adapter->last_req->header('Content-Type'), 'eq', 'application/x-www-form-urlencoded');

# PERCENTILE!

throws_ok { $keen->percentile('testing', { target_property => 'price' }) } qr/percentile/;

$keen->percentile('testing', { target_property => 'price', percentile => 90 });

cmp_ok($adapter->last_key, 'eq', $ENV{'KEEN_READ_KEY'});
cmp_ok($adapter->last_req->uri->as_string, 'eq', 'https://api.keen.io/3.0/projects/projectid/queries/percentile');
cmp_ok($adapter->last_req->method, 'eq', 'POST');

like($adapter->last_req->content, qr/percentile=90/, 'percentile has event_collection');
like($adapter->last_req->content, qr/event_collection=testing/, 'percentile has event_collection');
like($adapter->last_req->content, qr/target_property=price/, 'percentile has target_property');
cmp_ok($adapter->last_req->header('Content-Type'), 'eq', 'application/x-www-form-urlencoded');

# COUNT UNIQUE!

$keen->count_unique('testing', { target_property => 'price' });

cmp_ok($adapter->last_key, 'eq', $ENV{'KEEN_READ_KEY'});
cmp_ok($adapter->last_req->uri->as_string, 'eq', 'https://api.keen.io/3.0/projects/projectid/queries/count_unique');
cmp_ok($adapter->last_req->method, 'eq', 'POST');

like($adapter->last_req->content, qr/event_collection=testing/, 'count_unique has event_collection');
like($adapter->last_req->content, qr/target_property=price/, 'count_unique has target_property');
cmp_ok($adapter->last_req->header('Content-Type'), 'eq', 'application/x-www-form-urlencoded');

# SELECT UNIQUE!

$keen->select_unique('testing', { target_property => 'price' });

cmp_ok($adapter->last_key, 'eq', $ENV{'KEEN_READ_KEY'});
cmp_ok($adapter->last_req->uri->as_string, 'eq', 'https://api.keen.io/3.0/projects/projectid/queries/select_unique');
cmp_ok($adapter->last_req->method, 'eq', 'POST');

like($adapter->last_req->content, qr/event_collection=testing/, 'select_unique has event_collection');
like($adapter->last_req->content, qr/target_property=price/, 'select_unique has target_property');
cmp_ok($adapter->last_req->header('Content-Type'), 'eq', 'application/x-www-form-urlencoded');

# Extraction

$keen->extraction('testing');

cmp_ok($adapter->last_key, 'eq', $ENV{'KEEN_READ_KEY'});
cmp_ok($adapter->last_req->uri->as_string, 'eq', 'https://api.keen.io/3.0/projects/projectid/queries/extraction');
cmp_ok($adapter->last_req->method, 'eq', 'POST');

like($adapter->last_req->content, qr/event_collection=testing/, 'extraction has event_collection');
cmp_ok($adapter->last_req->header('Content-Type'), 'eq', 'application/x-www-form-urlencoded');

done_testing();
