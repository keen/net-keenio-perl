package WWW::KeenIO::HTTPAdapter;

use LWP::UserAgent;
use Moo;

my $BASE_URL = "https://api.keen.io";
my $VERSION = "3.0";

sub do_request {
  my ($self, $method, $url, $key, $body) = @_;

  my $ua = LWP::UserAgent->new;

  $ua->default_header('Authorization' => $key);


  my $req = HTTP::Request->new($method => "$BASE_URL/$VERSION/$url");
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
