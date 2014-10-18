package WWW::KeenIO;

use HTTP::Request::Common;
use JSON::MaybeXS;
use Moo;
use WWW::KeenIO::HTTPAdapter;

# ABSTRACT: FOO!

my $BASE_URL = "https://api.keen.io/3.0";

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

sub count {
  my ($self, $coll) = @_; # More!

  my $pid = $self->project_id;
  my $req = POST("$BASE_URL/projects/$pid/queries/count", 'Content-Type' => 'application/json', 'Content' => {
    event_collection => $coll
  });
  $self->http_adapter->do_request($req, $self->read_key);
}

sub publish {
  my ($self, $coll, $event) = @_;

  my $json = encode_json($event);

  my $pid = $self->project_id;

  my $req = POST("$BASE_URL/projects/$pid/events/$coll", 'Content-Type' => 'application/json', 'Content' => $json);

  $self->http_adapter->do_request($req, $self->write_key);
}

1;
