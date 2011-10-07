use MooseX::Declare;

class LaTeX::Beamer::Info::Page {

  has 'number'   => ( isa => 'Num', is => 'ro', required => 1 );
  has 'overview' => ( isa => 'Bool', is => 'rw', default => 0 );

  has 'is_start_page'  => ( isa => 'Bool', is => 'rw', default => 0 );
  has 'is_end_page'    => ( isa => 'Bool', is => 'rw', default => 0 );

  has 'starts_section' => ( 
    isa => 'LaTeX::Beamer::Info::Section', 
    is => 'rw', 
    clearer => 'clear_stars_section', 
    predicate => 'has_starts_section'
  );
  has 'starts_subsection' => ( 
    isa => 'LaTeX::Beamer::Info::Subsection', 
    is => 'rw', 
    clearer => 'clear_stars_subsection', 
    predicate => 'has_starts_subsection'
  );

  method props (Str $frame_transition?) {

    $frame_transition ||= 'PageTurn';

    my $text = "  " . $self->number() . ":\t{\n";

    if ($self->is_end_page) {
      $self->overview(1);
      $text .= "\t  'transition': $frame_transition,\n";
    }

    unless ($self->overview) {
      $text .= "\t  'overview': False,\n";
    }

    $text .= "\t},\n";
  }

}
