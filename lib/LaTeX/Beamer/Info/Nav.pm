use MooseX::Declare;

class LaTeX::Beamer::Info::Nav {

  use Carp;

  use Scalar::Util 'openhandle';

  use LaTeX::Beamer::Info::Frame;
  use LaTeX::Beamer::Info::Section;

  has 'file'   => ( isa => 'Str|FileHandle', is => 'ro', required => 1 );
  has 'frames' => ( 
    isa => 'ArrayRef[LaTeX::Beamer::Info::Frame]',
    is => 'rw',
    default => sub{ [] },
    traits  => ['Array'],
    handles => {
      add_frame => 'push',
      find_first => 'first',
    },
  );
  has 'sections' => ( 
    isa => 'ArrayRef[LaTeX::Beamer::Info::Section]',
    is => 'rw',
    default => sub{ [] },
    traits  => ['Array'],
    handles => {
      add_section => 'push',
      get_section => 'get',
    },
  );

  method BUILD ($) {
    my $file = $self->file;
    unless (openhandle($file)) {
      croak "Cannot find file: $file" unless (-e $file);
    }
  }

  method get_page (Num $num) {
    my $frame = $self->find_first( 
      sub { grep {$_ == $num} ($_->start_page .. $_->end_page) }
    ) or return 0;
    return $frame->pages->{$num};
  }

  method parse () {
    my $file = $self->file;
    my $fh;

    if (openhandle($file)) {
      $fh = $file;
    } else {
      open( $fh, '<', $file ) or croak "Could not open file: $file";
    }

    while (<$fh>) {
      if (/framepages {(\d+)}{(\d+)}/) {
        my $frame = LaTeX::Beamer::Info::Frame->new(
          start_page => $1,
          end_page   => $2,
        );
        $self->add_frame($frame);

      } elsif (/\\sectionentry {(\d+)}{([^\}]+)}{(\d+)}.*/) {
        my $section = LaTeX::Beamer::Info::Section->new(
          number     => $1,
          title      => $2,
          start_page => $3,
        );
        $self->add_section($section);

      } elsif (/\@subsectionentry {\d+}{(\d+)}{(\d+)}{(\d+)}{([^\}]+)}.*/) {
        #TODO handle subsection added before any section
        my $section = $self->get_section(-1);
        unless ($1 == $section->number) {
          carp "Attempted to add subsection ($4) to incorrect section (" . $section->title . ")";
        }
        my $subsection = LaTeX::Beamer::Info::Subsection->new(
          number     => $2,
          start_page => $3,
          tite       => $4,
          section    => $section,
        );
        $section->add_subsection($subsection);

      }
    }

    foreach my $section (@{ $self->sections }) {
      my $start_page = get_page( $section->start_page );
      unless ($start_page) {
        croak "Section: " . $section->title . " cannot be placed on a page (page was not found)";
      }
      $start_page->starts_section($section);

      foreach my $subsection (@{ $section->subsections }) {
        my $sub_start_page = get_page( $subsection->start_page );
        unless ($sub_start_page) {
          croak "Subsection: " . $subsection->title . " cannot be placed on a page (page was not found)";
        }
        $sub_start_page->starts_subsection($subsection);
      }
    }

    return $self;

  }

}
