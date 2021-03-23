use JSON::Tiny;

sub checkFile(Str $file) {return ($file.IO.slurp ==> from-json);};

sub PortTouch(Str $port,Str $max) {
  my %fluxModel =
            round => "",
            ('a' .. 'z').pick(10).join('') => [] ;
  for 0..+($max) {
    my $speaker = "speaker"~$_.gist ;
    %fluxModel{$speaker} = "";
  };
  my %pluginfo = checkFile "plugs/plugBoard.json";
  %pluginfo{$port} = [];
  %pluginfo{$port}.push(%fluxModel) ;
  spurt 'plugs/plugBoard.json', to-json(%pluginfo);
  say "Created a port with ",$max," speakers, in position ",$port;
};

sub Compile(Str $port) {
  my %pluginfo = checkFile "plugs/plugBoard.json";
  %pluginfo{"main"} = $port ;
  spurt 'plugs/plugBoard.json', to-json(%pluginfo);
  say "Compiled ",$port," as main"
};

sub Init(Str $port) {
  my %pluginfo = checkFile "plugs/plugBoard.json";
  my $check = %pluginfo{$port};
  my @stack ;
  if $check {
    say "------------starting pipeline------------";
    my %completeSys = %pluginfo{$port}[0];
    for %completeSys.keys -> $keys {
      if $keys~~/speaker/ {
        my $speaker0 = %completeSys{$keys};
        @stack.push(Thread.new(code=>{shell $speaker0}));
      };
    };
  } else {
    say "the port "~$port~" does not exist";
    die ;
  };
  @stack.map({$_.run});
};

sub Plug(@a,Str $port) {
  my %pluginfo = checkFile "plugs/plugBoard.json" ;
  my $t = %pluginfo.keys.contains($port);
  my @slots ;
  if $t {
    my %body = %pluginfo{$port}[0];
    (%body.keys).map({
      my $item = $_;
      if $item~~/speaker/ {
        @slots.push($item);
    }});
    @a.map({
      my $p = @a.first($_,:k);
      my $speakerUnique = $_;
      if $speakerUnique.contains("]") {
        my $enter = (%pluginfo{$port}[0].values).contains(split("]",$speakerUnique)[0];);
        if $enter {
          %pluginfo{$port}[0]{@slots[$p]} = "" ;
        } else {
          %pluginfo{$port}[0]{@slots[$p]} = split("]",$speakerUnique)[0];
        };
      } elsif $speakerUnique.contains("[") {
        my $enter = (%pluginfo{$port}[0].values).contains(split("[",$speakerUnique).tail);
        if $enter {
          %pluginfo{$port}[0]{@slots[$p]} = "" ;
        } else {
          %pluginfo{$port}[0]{@slots[$p]} = split("[",$speakerUnique).tail;
        };
      } else {
        my $enter = (%pluginfo{$port}[0].values).contains($speakerUnique);
        if $enter {
          %pluginfo{$port}[0]{@slots[$p]} = "" ;
        } else {
          %pluginfo{$port}[0]{@slots[$p]} = $speakerUnique;
        };
      };
    });
  };
  spurt 'plugs/plugBoard.json', to-json(%pluginfo);
  say "Done!";
};

sub MAIN(Str $mode="",Str $port?="",$a?="", Str $b?="") {
  try {
  if $mode === "run" {
    Init $port;
  } elsif $mode === "compile" {
    Compile $port ;
  } elsif $mode === "insert" {
    my @a = split ',',$a ;
    Plug @a, $port ;
  } elsif $mode === "touch" {
    PortTouch $port,$a ;
  } elsif $mode === "main" {
    if $port === "plot" {
      try {
        my $t = Thread.new(code=>{shell "python VizualizePorts.py"});
        $t.run();
        CATCH {
          die "something went wrong";
        };
      };
    };
    (checkFile "plugs/plugBoard.json"){'main'} ==> Init ;
  } elsif $mode === "show" {
    my %data = (checkFile "plugs/plugBoard.json"){$port}[0] ;
    (%data.keys).map({
      if %data{$_} === "" {
        say $_ , " :: "," not connected ";
      }else{
        say $_ , " :: ",%data{$_};
        };
      });
    };
  };
  CATCH {
    die "unexpected error whithin shell commands";
  };

};

# workflow =>
  # perl6 core.p6 touch <port> <number of speakers> -- create the port
  # perl6 core.p6 insert <port> <[commands]> -- insert the commands not in order
  # perl6 core.p6 show <port> -- to show all the speakers
  # perl6 core.p6 run <port> -- run specific port and test
  # perl6 core.p6 compile <port> -- you put this port as the main port
  # perl6 core.p6 main <optinal plot> -- run the main port, if plot the speaker will be plotted
