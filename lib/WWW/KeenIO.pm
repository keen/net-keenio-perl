package WWW::KeenIO;

use Data::Dumper;
use JSON::MaybeXS;
use LWP::UserAgent;
use Moo;

# ABSTRACT: FOO!

my $BASE_URL = "https://api.keen.io";
my $VERSION = "3.0";

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

sub publish {
  my ($self, $coll, $event) = @_;

  my $json = encode_json($event);

  my $pid = $self->project_id;
  $self->do_request("POST", "$BASE_URL/$VERSION/projects/$pid/events/$coll", $self->write_key, $json)
}

sub do_request {
  my ($self, $method, $url, $key, $body) = @_;

  my $ua = LWP::UserAgent->new;

  $ua->default_header('Authorization' => $key);


  my $req = HTTP::Request->new($method => $url);
  $req->content_type('application/json');
  $req->content($body);

  my $res = $ua->request($req);
  if ($res->is_success) {
    print $res->content;
  }
  else {
    print $res->status_line, "\n";
  }

}

1;
