#!/usr/bin/env perl
#
$HELP = 'Create a list (default list-separator=" ") of prefixed words for a given whitespace or comma separated string';
$USAGE = '[-ucfirst] [-sep=list-separator]  prefix string ';

@args = ();
$sep = ' ';
while (@ARGV){
  local $_ = shift;
  chomp;
  if(/^-ucfirst/){ 
    $ucfirst = 1 ; 
  }elsif(/^-sep/ or /^-list-separator/) { 
    (undef,$sep) = split (/=/, $_);
  }elsif(/^-/) { 
    die "usage: $usage"
  }else{
    push @args, $_;
  }
}

$prefix = $args[0];
$string = $args[1];

#print 'pf  ' . $prefix . "\n";

die "usage: $USAGE" unless $string;
die "usage: $USAGE" unless $prefix;

@xtags=();
foreach(split(/[\s\,]+/, $string)){
   s/^\s+|\s+$//g;
   if($_){
      my ($f,$r) = split(//,$_,2);

      if($f eq $prefix){
         if($ucfirst){
            push @xtags, ($prefix . ucfirst(lc($r)));
         }else{
            push @xtags, ($prefix . lc($r));
         }
      }else{
         if($ucfirst){
            push @xtags, ($prefix . ucfirst(lc($_)));
         }else{
            push @xtags, ($prefix . lc($_));
         }
      }
   }
}

print join($sep, @xtags);
