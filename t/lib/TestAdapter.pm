package TestAdapter;

use Moo;

has 'last_body' => (
  is => 'rw'
);

has 'last_key' => (
  is => 'rw'
);

has 'last_method' => (
  is => 'rw'
);

has 'last_url' => (
  is => 'rw'
);

sub do_request {
  my ($self, $method, $url, $key, $body) = @_;
  $self->last_method($method);
  $self->last_url($url);
  $self->last_key($key);
  $self->last_body($body);
}

1;
