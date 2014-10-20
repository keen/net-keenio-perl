package WWW::KeenIO;

use HTTP::Request::Common;
use JSON::MaybeXS;
use Moo;
use WWW::KeenIO::HTTPAdapter;

# ABSTRACT: FOO!

=head1 SYNOPSIS

  # With no args we'll use the following environment variables:
  # KEEN_PROJECT_ID
  # KEEN_MASTER_KEY
  # KEEN_WRITE_KEY
  # KEEN_READ_KEY
  my $keen = WWW::KeenIO->new();

  # Or, supply your own!
  my $keen = WWW::KeenIO->new(
    project_id => 'whatever',
    master_key => 'master_key',
    write_key => 'write_key',
    read_key => 'read_key'
  );

  # Send an event by providing a collection name and a hashref
  # It will be automatically stringified by JSON::MaybeXS
  # Returns an HTTP::Response object!

  $keen->publish('signups', {
    username => 'lloyd',
    referred_by => 'harry'
  });

  # See how many signups we got with a count query.
  # Returns an HTTP::Response object!

  my $resp = $keen->count("signups");
  my $res = decode_json($resp->decoded_content);
  say $res->{'result'};

=cut

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
  default => sub { WWW::KeenIO::HTTPAdapter->new() }
);

sub count {
  my ($self, $coll) = @_;

  my $pid = $self->project_id;
  my $req = POST("$BASE_URL/projects/$pid/queries/count", 'Content' => {
    event_collection => $coll
  });
  $self->http_adapter->do_request($req, $self->read_key);
}

sub count_unique {
  my ($self, $coll, $args) = @_;

  $self->_do_targeted_query('count_unique', $coll, $args)
}

sub extraction {
  my ($self, $coll, $args) = @_;

  $args->{event_collection} = $coll;

  my $pid = $self->project_id;
  my $req = POST("$BASE_URL/projects/$pid/queries/extraction", 'Content' => $args);
  $self->http_adapter->do_request($req, $self->read_key);
}

sub maximum {
  my ($self, $coll, $args) = @_;

  $self->_do_targeted_query('maximum', $coll, $args)
}

sub median {
  my ($self, $coll, $args) = @_;

  $self->_do_targeted_query('median', $coll, $args)
}

sub minimum {
  my ($self, $coll, $args) = @_;

  $self->_do_targeted_query('minimum', $coll, $args)
}

sub percentile {
  my ($self, $coll, $args) = @_;

  if(!exists($args->{'percentile'})) {
    die "Your must supply a percentile value to percentile!";
  }

  $self->_do_targeted_query('percentile', $coll, $args)
}

sub publish {
  my ($self, $coll, $event) = @_;

  my $json = encode_json($event);

  my $pid = $self->project_id;

  my $req = POST("$BASE_URL/projects/$pid/events/$coll", 'Content-Type' => 'application/json', 'Content' => $json);

  $self->http_adapter->do_request($req, $self->write_key);
}

sub select_unique {
  my ($self, $coll, $args) = @_;

  $self->_do_targeted_query('select_unique', $coll, $args)
}

sub sum {
  my ($self, $coll, $args) = @_;

  $self->_do_targeted_query('sum', $coll, $args)
}

sub _do_targeted_query {
  my ($self, $type, $coll, $args) = @_;

  if(!defined($args) || !exists($args->{target_property})) {
    die "You must supply a target_property to $type!";
  }

  $args->{event_collection} = $coll;

  my $pid = $self->project_id;
  my $req = POST("$BASE_URL/projects/$pid/queries/$type", 'Content' => $args);
  $self->http_adapter->do_request($req, $self->read_key);
}

1;
