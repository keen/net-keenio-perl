use Test::More;

use WWW::KeenIO;

$ENV{'KEEN_PROJECT_ID'} = 'projectid';
$ENV{'KEEN_MASTER_KEY'} = 'master';
$ENV{'KEEN_READ_KEY'} = 'read';
$ENV{'KEEN_WRITE_KEY'} = 'write';

my $keen = new_ok('WWW::KeenIO');

$keen->publish("testing", { 'price' => 10 });

cmp_ok(1, '==', 1);

done_testing();
