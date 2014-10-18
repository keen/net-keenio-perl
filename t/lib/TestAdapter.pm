package TestAdapter;

use Moo;

has 'last_req' => (
  is => 'rw'
);

has 'last_key' => (
  is => 'rw'
);

sub do_request {
  my ($self, $req, $key) = @_;
  $self->last_req($req);
  $self->last_key($key);
}

1;
