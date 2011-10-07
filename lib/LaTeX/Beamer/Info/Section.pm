use MooseX::Declare;

class LaTeX::Beamer::Info::Section {
  has 'number'     => ( isa => 'Num', is => 'ro', required => 1 );
  has 'title'      => ( isa => 'Str', is => 'ro', required => 1 );
  has 'start_page' => ( isa => 'Num', is => 'ro', required => 1 );

  has 'subsections' => ( 
    isa => 'ArrayRef[LaTeX::Beamer::Info::Subsection]',
    is => 'rw', 
    default => sub{ [] },
    traits  => ['Array'],
    handles => {
      add_subsection => 'push',
    }
  );

}

class LaTeX::Beamer::Info::Subsection 
  extends LaTeX::Beamer::Info::Section {

  has 'section'  => ( isa => 'LaTeX::Beamer::Info::Section', is => 'ro', required => 1 );
  has 'collapse' => ( isa => 'Bool', is => 'rw', default => 0 );

}
