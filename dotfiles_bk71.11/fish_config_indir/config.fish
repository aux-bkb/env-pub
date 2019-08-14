#
#
#function fish_user_key_bindings
#     bind \cl clear
#     bind -M default \$ end-of-line accept-autosuggestion
#end
#fish_vi_key_bindings
#set -g fish_escape_delay_ms 10

#
#" fish_vi_modl
#
# start in insert mode
#fish_vi_key_bindings insert

#set FUNCTIONS $HOME/.config/fish/functions

if [ -f /usr/libexec/java_home ]
   set -gx JAVA_HOME (/usr/libexec/java_home)
end
set -g JAVA_VERS 1.8
set -g ANDROID_BUILD_TOOLS_VERS 28.0.2 

# github token for bensrc
set -g HOMEBREW_GITHUB_API_TOKEN 2f46a32d824965607d82ce9e447e4aa0501b4b71

if [ -d $FUNCTIONS ] 
   #echo source $FUNCTIONS/my_fish_vi_key_bindings.fish

#  problems with paste in macosx, therefore disabled:  set -g fish_key_bindings my_fish_vi_key_bindings
end

set -gx GPG_TTY (/usr/bin/tty)

# do I have to run ???
# exec ssh-agent fish 

# PATH
set -gx PATH 
set -l sysbins /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin  /opt/local/bin /usr/local/texlive/2018/bin/x86_64-darwin

set -l homebins $HOME/local/bin $HOME/.local/bin $HOME/opt/bin $HOME/.bin $HOME/.pub-cache/bin

for bin in $sysbins $homebins
   test -d $bin ; and set -gx PATH $bin $PATH
end

# opam separate because its messing with the PATH
# set initfile $HOME/.opam/opam-init/init.fish
# [ -f "$initfile" ] ; and source "$initfile" > /dev/null 2> /dev/null ; or true


set config_fish $HOME/.config/fish/conf 
if [ -d $config_fish ] 
   for f in $config_fish/*.fish
      if [ -f $f ] 
         source $f
      end
   end
end

# printf "\e[?2004l"
#echo ppp $PATH
