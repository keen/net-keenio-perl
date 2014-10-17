package WWW::KeenIO;
use JSON::Any;
use Moo;

# ABSTRACT: FOO!

has 'project_id' => (
  is => 'ro',
  default => sub { $ENV{'KEEN_PROJECT_ID'} }
);
has 'master_key' => (
  is => 'ro',
  default => sub { $ENV{'KEEN_MASTER_KEY'} }
);
has 'write_key' => (
  is => 'ro',
  default => sub { $ENV{'KEEN_WRITE_KEY'} }
);
has 'read_key' => (
  is => 'ro',
  default => sub { $ENV{'KEEN_READ_KEY'} }
);

1;
