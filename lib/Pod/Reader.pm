package Pod::Reader;

use Curses::UI;
use File::Find;
use Carp qw#croak#;
use 5.10.1;

use vars qw#*name#;
*name   = *File::Find::name;

if ($ENV{PAGER} =~ m/more/) {
    croak "$0 doesn't work with 'more' set as a PAGER.\n"
    . "Please switch to a different one (less or most for instance).";
}

my @searchdirs = ();
my $searchpath = shift @ARGV;

if ($searchpath && -d $searchpath) {
    push @searchdirs, $searchpath;
} else {
    local @INC = @INC;
    pop @INC if $INC[-1] eq '.';
    push @searchdirs, grep { -d $_ } @INC;
}

my @dotpms = ();

File::Find::find(\&wanted, @searchdirs);

sub wanted {
    -f _ &&
    /^.*\.pm$/s
    && push @dotpms, "$name\n";
}

my $cui = Curses::UI->new(
    -color_support => 1,
    -clear_on_exit => 1,
    -mouse_support => 1
);

sub exit_dialog {
    my $rc = $cui->dialog(
        -title   => 'Quit PodReader?',
        -message => 'Do you really want to quit?',
        -tfg     => 'red',
        -fg      => 'red',
        -buttons => [
            { -label => '[ Yes ]' },
            { -label => '[ No ]' }
        ]
    );
    exit(0) if $rc eq 0;
}

my $main = $cui->add('main', 'Window');

my $header = $main->add(
    'header', 'Label',
    -text          => 'PodReader',
    -textalignment => 'left',
    -bold          => 1,
    -fg            => 'white',
    -bg            => 'blue',
    -y             => 0,
    -width         => -1,
    -paddingspaces => 1,
);

my $main_window = $cui->add(
    'main_window', 'Window',
    -padtop    => 2,
    -padbottom => 3
);

my $top_label = $main_window->add(
    'top_label', 'Label',
    -text    => 'Please select a Perl module in the list below to read documentation from:',
    -padleft => 1,
    -fg      => 'blue',
    -width   => -1
);

my $main_listbox = $main_window->add(
    'main_listbox', 'Listbox',
    -y          => 2,
    -padleft    => 1,
    -padright   => 1,
    -padbottom  => 0,
    -fg         => 'blue',
    -bg         => 'black',
    -wraparound => 1,
    -onchange   => \&main_listbox_onchange,
    -values     => \@dotpms
);

sub main_listbox_onchange {
    my $pm = $main_listbox->get();
    chomp $pm;
    my @perldoc = ('perldoc', $pm);
    $cui->leave_curses();
    system (@perldoc);
    $cui->reset_curses();
    $main_listbox->focus();
}

my $footer = $main->add(
    'footer', 'Label',
    -text          => '[Ctrl+q] Quit',
    -textalignment => 'left',
    -bold          => 1,
    -bg            => 'black',
    -fg            => 'white',
    -y             => -1,
    -width         => -1,
    -paddingspaces => 1,
);

$top_label->draw();
$header->draw();
$footer->draw();

$main_window->draw();
$main_window->focus();

$cui->set_binding(\&exit_dialog, "\cQ");
$cui->mainloop;

1;
