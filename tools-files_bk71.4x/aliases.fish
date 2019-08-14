set TOOLS "$HOME/tools" 
set UTILS "$TOOLS/utils"
set CMDS "$TOOLS/cmds"
set MOREUTILS "$TOOLS/moreutils"
set MOREUTILSBIN "$TOOLS/moreutils-bin"

set XCODE "/Applications/Xcode.app/Contents/Developer"
alias ios_clang "$XCODE/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"

alias obt $CMDS/org-babel-tangle

alias dev-sw-opensource "sh $MOREUTILS/devutils/sw-opensource.sh"

alias ssh-load-ssh-keys "sh $MOREUTILS/ssh/load_ssh_keys.sh"
alias twikpw "perl $MOREUTILS-bin/twikpw.pl"
alias pwdhash "bash $TOOLS/moreutils-bin/pwdhash.bash"
alias pwcalc "sh $TOOLS/moreutils-bin/pwcalc.sh"
alias ssh-createkey "sh $TOOLS/moreutils-bin/ssh-createkey.sh"
alias hxrun "sh $TOOLS/moreutils/haxe/hxrun.sh"

set d del

alias sd "$UTILS/searchdir"
alias mo "$UTILS/move"

alias rn "rename"

alias pc "$UTILS/pwdcopy"

function j 
   set jdir (/bin/sh $HOME/aux/utils/java-switch $argv[1])
   set -gx JAVA_HOME "$jdir"
   echo run java -version
end


function m
   mkdir -p $argv[1] ; and cd $argv[1]
end


function die
   echo $argv
   exit 1
end

function go_to_stdout
   set out (/bin/sh $HOME/aux/utils/stdout)
   echo out $out
   if [ -d "$out" ] 
      cd "$out"
   else if [ -f "$out" ]
      switch "$out"
         case *.html
            open "$out"
         case '*'
            open -a MacVim "$out"
         end
   else
       echo "Warn: no file of dir"
   end
end

# alias go "go_to_stdout"

alias gtr 'go_to_res'

alias b "bkb-decimals"

alias aa "archive-article"

function cd_to_bkb-decimal 
   set matches (bkb-decimals $argv)
   switch (count $matches)
      case 1
         cd $HOME/decimals/$matches
      case 0
         die "Err: no matches"
      case '*'
         die "Err: too many matches"
   end
end
alias cb cd_to_bkb-decimal 

function cd_syncdir_bkb
   set syncdir_bkb $HOME/base/syncdir_bkb_skyfall
   set homebase $HOME/base
   pushd $homebase/*/*$argv[1]*
end

function cd_syncdir_bkb_sub
   set syncdir_bkb $HOME/base/syncdir_bkb_skyfall
   set homebase $HOME/base
   set length (string length $argv[1])
   set path ''
   switch $length
      case 3
         set path $homebase/*/*bkb*/*_$argv[1]*
      case 5
         set path $homebase/*/*bkb*/*/*_$argv[1]*
      case 2
         set path $homebase/*/*bkb*/*_$argv[1]
      case '*'
         set path $homebase/*/*bkb*/*_$argv[1]
   end

   if test -z "$path"
     set path $homebase/*/*bkb*/*/*_$argv[1]
     [ -z "$path" ]; and die "Err1: could not find path in $argv[1]"
     [ -d "$path" ]; or die "Err:2 could not find path in $argv[1]"
      pushd "$path"
   else if test -d "$path"
     pushd $path
   else
     echo "Err: invalid path in $argv[1]"
     echo "   Here is result"
     echo $path
   end
end
 
set redir $HOME/base/redir

alias 1x 'find -L ~/base  -maxdepth 3  -path $redir -prune -o -type d | perl -ne "/_1[\d(-\d\d)]/ && print"'
alias 2x 'find -L ~/base  -maxdepth 3  -path $redir -prune -o -type d | perl -ne "/_2[\d(-\d\d)]/ && print"'
alias 3x 'find -L ~/base  -maxdepth 3  -path $redir -prune -o -type d | perl -ne "/_3[\d(-\d\d)]/ && print"'
alias 4x 'find -L ~/base  -maxdepth 3  -path $redir -prune -o -type d | perl -ne "/_4[\d(-\d\d)]/ && print"'
alias 5x 'find -L ~/base  -maxdepth 3  -path $redir -prune -o -type d | perl -ne "/_5[\d(-\d\d)]/ && print"'
alias 6x 'find -L ~/base  -maxdepth 3  -path $redir -prune -o -type d | perl -ne "/_6[\d(-\d\d)]/ && print"'
alias 7x 'find -L ~/base  -maxdepth 3  -path $redir -prune -o -type d | perl -ne "/_7[\d(-\d\d)]/ && print"'
alias 8x 'find -L ~/base  -maxdepth 3  -path $redir -prune -o -type d | perl -ne "/_8[\d(-\d\d)]/ && print"'
alias 9x 'find -L ~/base  -maxdepth 3  -path $redir -prune -o -type d | perl -ne "/_9[\d(-\d\d)]/ && print"'

alias bb 'cd_syncdir_bkb_sub'

alias b1 'cd_syncdir_bkb b1'
alias b2 'cd_syncdir_bkb b2'
alias b3 'cd_syncdir_bkb b3'
alias b4 'cd_syncdir_bkb b4'
alias b5 'cd_syncdir_bkb b5'
alias b6 'cd_syncdir_bkb b6'
alias b7 'cd_syncdir_bkb b7'
alias b8 'cd_syncdir_bkb b8'
alias b9 'cd_syncdir_bkb b9'
alias b10 'cd_syncdir_bkb b10'
alias b11 'cd_syncdir_bkb b11'
alias b12 'cd_syncdir_bkb b12'

alias nsb 'source ~/aux/utils/node-switch bkb'
alias nlb 'source ~/aux/utils/node-list bkb'

alias nsa 'source ~/aux/utils/node-switch aux-bkb'
alias nla 'source ~/aux/utils/node-list aux-bkb'

alias na 'source ~/aux/utils/node-switch aux-bkb'

alias twikpw-ben 'twikpw ben_2P0a.pwc-ii'

alias chrome "/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias rm  "rm -f"
alias passtab-bkb_1U0a 'passtab-profile bkb_1U0a'
alias hap hashapass
alias pw-seven-bkb 'pw "bkb_H3-0c-ii" "seven;bkb;###"'
alias pw-seven-root 'pw "admin_H3-0c-ii" "seven;root+ssh;###"'
alias pw-ronin-admin 'pw "admin_H3-0c-ii" "ronin;admin"'
alias pw-fritz-admin 'pw "admin_H3-0c-ii" "fritz;admin"'
alias pw-topgun-admin 'pw "admin_H3-0c-ii" "topgun;admin"'
alias pw-topgun-jakobshare 'pw "jakob_H3-0c" "topgun;jakobshare;##"'

alias . "ls ."
alias fm "urxvtc -e /usr/local/bin/vifm"

alias love "/Applications/love.app/Contents/MacOS/love"

alias xreload "xrdb ~/.Xresources"
alias cdd "cd ~/dev/"
alias cdi "cd ~/dev/i"
alias cdr "cd ~/dev/repos"

alias today 'date "+%F"'
alias now 'date "+%F %T"'

alias sf "showfile"

alias u untar

alias ssh-restart "sudo service ssh restart"
alias sshr ssh-restart

alias apts "apt-cache search"
alias apti "sudo apt-get install"
alias aptu "sudo apt-get update"

alias chmox "chmod 0755"

#alias copy "xclip -sel clip"
#alias paste "xclip -sel clip -o"


#alias ack "ack-grep"

alias upl "/home/bkb/local/perl/upl/upl -I /home/bkb/local/perl/upl/lib"

alias l "ls -Fhtlr"
alias sl "ls"


alias worg "mvim --remote-silent"

alias lizpop "python -O -m lizpop.run"
alias lp "python -O -m lizpop.run"

# tmux
alias tmuxlist "tmux list-sessions"
alias txl tmuxlist
alias tmuxl tmuxlist

alias mp "mkdir -p "
alias mkdri "mkdir -p"

alias shortdate 'date +"%Y-%m-%d"'

alias sshkeyless "ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no"

function go_to_item
   set target $argv[1]
   set item $argv[2]

   set dir (/bin/sh $TOOLS/utils/decimals/get-id.sh "$target" "$item")
   if [ -d "$dir" ] 
     echo Change to $dir
     cd $dir
   else
     echo Cannot change dir
   end
end

function go_to_item_parent
   set target $argv[1]
   set item $argv[2]

   set dir (/bin/sh $TOOLS/moreutils/decimals/get-id.sh "$target" "$item")
   if [ -d "$dir" ] 
     echo "Change to '$target' $dir"
     cd (dirname $dir)
   else
     echo Cannot change dir
   end
end

function show_item
   set target $argv[1]
   set item $argv[2]

   set dir (/bin/sh $TOOLS/moreutils/decimals/get-id.sh "$target" "$item")
   if [ -d "$dir" ] 
     echo $dir
   else
     echo Cannot Show 
   end
end


function link_to_item
   set target $argv[1]
   set folder $argv[2]

   set targetdir (/bin/sh $TOOLS/moreutils/decimals/get-id.sh $target $folder)

   if [ -d "$targetdir" ] 
     set btarget (basename $targetdir)
     rm -f $btarget.$target
     ln -s $targetdir $btarget.$target
     echo "link target '$targetdir' to '$btarget.$target'"
   else
     echo Cannotx change dir
   end
end

function link_to_item_parent
   set target $argv[1]
   set folder $argv[2]

   set targetdir (/bin/sh $TOOLS/moreutils/decimals/get-id.sh $target $folder)
   set targetdirparent (dirname $targetdir)

   if [ -d "$targetdirparent" ] 
     set btarget (basename $targetdirparent)
     rm -f $btarget.$target
     ln -s $targetdirparent $btarget.$target
     echo "link target parent '$targetdirparent' to '$btarget.$target'"
   else
     echo "Cannotx link dir '$targetdir'"
   end
end

alias gi 'go_to_item'
alias gip 'go_to_item_parent'

alias li 'link_to_item'
alias lip 'link_to_item_parent'

alias si 'show_item'

alias refish "source $HOME/.config/fish/config.fish"
alias 'decimal-link' "sh $TOOLS/moreutils/decimals/link-decimal.sh"

alias 'clean-filename' "sh $HOME/r/utils/clean-filename.sh"
alias 'filename-clean' "sh $HOME/r/utils/clean-filename.sh"

function resource 
   source ~/tools/aliases.fish
end

set INFOTOOLS "$HOME/tools/autoscripts/infotools"

alias 'stamp-date' "sh $INFOTOOLS/stamp-date.sh"
alias 'stamp-crock' "sh $INFOTOOLS/stamp-crock.sh"
alias 'stamp-base26' "sh $INFOTOOLS/stamp-base26.sh"
alias 'stamp-minute' "sh $INFOTOOLS/stamp-minute.sh"

set ONETOOLS "$HOME/tools/autoscripts/onetools"
alias 'one-vim' "sh $ONETOOLS/one-vim.sh"

alias 'webref-dl' "bash $INFOTOOLS/webref-dl.bash"
# webref-dl.bash
#alias 'one-find-stamp' "sh $INFOTOOLS/one-find-stamp.sh"
# one-last-line.sh
# one-last-show.sh
# one-ls.sh
# one-new.sh
# one-read-stamp.sh

set DECIMALS $MOREUTILS/decimals_bk71.45.16
alias 'dec-id' "sh $DECIMALS/dec-id.sh" 
alias 'dec-folder-id' "sh $DECIMALS/dec-folder-id.sh" 

alias 'ssh-load-key' "sh $MOREUTILSBIN/ssh-load-key.sh"
