use Test::More;

use Net::KeenIO;

$ENV{'KEEN_PROJECT_ID'} = 'abcproject';
$ENV{'KEEN_MASTER_KEY'} = 'masterkey';
$ENV{'KEEN_READ_KEY'} = 'readkey';
$ENV{'KEEN_WRITE_KEY'} = 'writekey';

my $keen = new_ok('Net::KeenIO');

cmp_ok($keen->project_id, 'eq', 'abcproject');
cmp_ok($keen->master_key, 'eq', 'masterkey');
cmp_ok($keen->read_key, 'eq', 'readkey');
cmp_ok($keen->write_key, 'eq', 'writekey');

my $custom_keen = new_ok('Net::KeenIO' => [
  project_id => 'A',
  master_key => 'B',
  read_key => 'C',
  write_key => 'D'
]);

cmp_ok($custom_keen->project_id, 'eq', 'A');
cmp_ok($custom_keen->master_key, 'eq', 'B');
cmp_ok($custom_keen->read_key, 'eq', 'C');
cmp_ok($custom_keen->write_key, 'eq', 'D');

done_testing();
