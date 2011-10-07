use MooseX::Declare;

class LaTeX::Beamer::Info::Frame {

  use Carp;

  use LaTeX::Beamer::Info::Page;

  has 'start_page' => ( isa => 'Num', is => 'ro', required => 1 );
  has 'end_page'   => ( isa => 'Num', is => 'ro', lazy => 1, builder => '_make_end_page' );
  has 'pages'      => ( isa => 'HashRef[LaTeX::Beamer::Info::Page]', is => 'rw', lazy => 1, builder => '_make_pages' );

  method _make_end_page () {
    return $self->start_page;
  }

  method _make_pages () {
    
    if ($self->start_page > $self->end_page) {
      croak "Frame start_page is greater than end_page";
    }

    my $pages = {};
    foreach my $page ($self->start_page .. $self->end_page) {
      $pages->{$page} = LaTeX::Beamer::Info::Page->new(
        number => $page,
      );
    }
    $pages->{$self->start_page}->is_start_page(1);
    $pages->{$self->end_page}->is_end_page(1);
    return $pages;
  }

}
