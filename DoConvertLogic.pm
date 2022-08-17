package DoConvertLogic;

use Moose;

use BOSS::Config;
# use MyFRDCSA;
use PerlLib::SwissArmyKnife;

has Config =>
  (
   is => 'rw',
   isa => 'BOSS::Config',
  );

sub BUILD {
  my ($self,$args) = @_;
  my %args = %$args;
  my $specification = "
	-u [<host> <port>]	Run as a UniLang agent

	-w			Require user input before exiting
";
  # $UNIVERSAL::systemdir = ConcatDir(Dir("internal codebases"),"doconvertlogic");
  $self->Config
    (BOSS::Config->new
     (Spec => $specification,
      ConfFile => ""));
  my $conf = $self->Config->CLIConfig;
  if (exists $conf->{'-u'}) {
    $UNIVERSAL::agent->DoNotDaemonize(1);
    $UNIVERSAL::agent->Register
      (Host => defined $conf->{-u}->{'<host>'} ?
       $conf->{-u}->{'<host>'} : "localhost",
       Port => defined $conf->{-u}->{'<port>'} ?
       $conf->{-u}->{'<port>'} : "9000");
  }
}

sub Execute {
  my ($self,%args) = @_;
  my $conf = $self->Config->CLIConfig;
  if (exists $conf->{'-u'}) {
    # enter in to a listening loop
    while (1) {
      $UNIVERSAL::agent->Listen(TimeOut => 10);
    }
  }
  if (exists $conf->{'-w'}) {
    Message(Message => "Press any key to quit...");
    my $t = <STDIN>;
  }
}

sub ProcessMessage {
  my ($self,%args) = @_;
  my $m = $args{Message};
  my $it = $m->Contents;
  if ($it) {
    if ($it =~ /^echo\s*(.*)/) {
      $UNIVERSAL::agent->SendContents
	(Contents => $1,
	 Receiver => $m->{Sender});
    } elsif ($it =~ /^(quit|exit)$/i) {
      $UNIVERSAL::agent->Deregister;
      exit(0);
    }
  }
  my $d = $m->Data;
  print Dumper({M => $m});
  if ($d->{Command} eq 'ProcessChasedFile') {
    $UNIVERSAL::agent->QueryAgentReply
      (
       Message => $args{Message},
       Contents => '',
       Data => {
		_DoNotLog => 1,
		Result => '((value . t))',
	       },
      );
    $self->ProcessChasedFile(ChasedFile => $d->{ChasedFile})
  }
}

sub ProcessChasedFile {
  my ($self,%args) = @_;
  my $f = $args{ChasedFile};
  if (-f $f) {
    my $command1 =
      'cd /var/lib/myfrdcsa/codebases/minor/do-convert/scripts && ./do-convert-parsecheck-and-convert-to-prolog.pl -f '.shell_quote($f);
    print $command1;
    # "$VAR1 = {
    #           'Res1' => '((value . \"Parsecheck correct\"))
    # '
    #         };
    # "
    my $result = `$command1`;
    print "<<<$result>>>\n";
    if ($result eq '((value . "Parsecheck correct"))'."\n") {
      # now processed to conversion to prolog
      system 'cd /var/lib/myfrdcsa/codebases/minor/do-convert/data/do-convert-git/results && git add .';
      system 'EXECUTION_ENGINE= && cd /var/lib/myfrdcsa/codebases/minor/do-convert/data/do-convert-git/results && git commit . -m "automatically updated"';
    }
  }
}

1;
