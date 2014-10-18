package WWW::KeenIO;

use JSON::MaybeXS;
use Moo;
use WWW::KeenIO::HTTPAdapter;

# ABSTRACT: FOO!

has 'master_key' => (
  is => 'ro',
  default => sub { $ENV{'KEEN_MASTER_KEY'} }
);
has 'project_id' => (
  is => 'ro',
  default => sub { $ENV{'KEEN_PROJECT_ID'} }
);
has 'read_key' => (
  is => 'ro',
  default => sub { $ENV{'KEEN_READ_KEY'} }
);
has 'write_key' => (
  is => 'ro',
  default => sub { $ENV{'KEEN_WRITE_KEY'} }
);
has 'http_adapter' => (
  is => 'ro',
  default => sub { new WWW::KeenIO::HTTPAdapter() }
);

sub publish {
  my ($self, $coll, $event) = @_;

  my $json = encode_json($event);

  my $pid = $self->project_id;
  $self->http_adapter->do_request("POST", "/projects/$pid/events/$coll", $self->write_key, $json)
}

1;
