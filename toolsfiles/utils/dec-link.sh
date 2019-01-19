#!/bin/sh

# dec-folder : foobar_11.33, notes_2x
##   dec-name: foobar, notes
##   dec-token: 11.33, 2x 

# Unique Node Identified dec-folder
#    unidec-folder/-link: foobar_11.33.hs2i notes_2x.cd1o
##   unidec-token: 11.33.hs2i, 2x.cd1o
##   node-id: hs2i, cd1o 


unidec_conf_file=$1 

decdir=$HOME/dec
redir=$HOME/r
unidec_home=$HOME/homebase/unidec

unidec_conf_dotfile=$HOME/.unidec.conf

die () { echo $@; exit 1; }


init_dirs () {
  for d in $decdir $redir $unidec_home ; do
    mkdir -p $d
  done
  rm -f $redir/dec
  ln -s $decdir $redir/dec

  rm -f $redir/unidec
  ln -s $unidec_home $redir/unidec

}

link_conf_entries () {
   [ -d "$unidec_home" ] || die "Err: no unidec_home under '$unidec_home', run ~/aux/env-pub/unidecs-install.sh first"

   cat $unidec_conf_file | while read ln ; do
      declink="$unidec_home/$ln" 
      if [ -L "$declink" ] ; then
         decpath=$(readlink $declink)
         if [ -d "$decpath" ] ; then
            link_path $decpath
          fi

      fi
   done
}



link_path () {
   local xdec_path=$1
   local register_in_conf_dotfile=$2
   [ -d "$xdec_path" ] || die "Err: unidec location $xdec_path not existing"

   local xdec_folder=$(basename $xdec_path) # not clear which type: dec, or unidec

   local dec_name=${xdec_folder%_*}
   local xdec_token=${xdec_folder##*_}

   local err=
   local dec_token= 
   local node_id= 
   case "$xdec_token" in
      [0-9][0-9].[0-9][0-9])
         dec_token=$xdec_token
         local node_basename=$(basename $(dirname "$xdec_path"))
         node_id=${node_basename##*.}
         case "$node_id" in
            [a-z][a-z][0-9]*[a-z]) : ;;
            *) err="Err: node_token $node_id invalid" ;;
         esac
      ;;
      [0-9][0-9].[a-z][a-z][0-9]*[a-z])
         dec_token=${xdec_token%.*}
         node_id=${xdec_token##*.}
      ;;
      [0-9]*.[a-z][a-z][0-9]*[a-z])
         dec_token=${xdec_token%.*}
         node_id=${xdec_token##*.}
         ;;
      *)
         err="todo: unidec in form of '$xdec_token'" 
      ;;
   esac

   if [ -n "$err" ] ; then 
    echo "warn: " $err
   else
    unidec_token=${dec_token}.$node_id
    unidec_folder=${dec_name}_${unidec_token}
    dec_folder=${dec_name}_${dec_token}

    rm -f $decdir/$dec_folder
    ln -s $xdec_path $decdir/$dec_folder

    rm -f $redir/$dec_folder
    ln -s $xdec_path $redir/$dec_folder
    echo "OK: linked to ~/dec and ~/r:  '$xdec_path'  to '$decdir/$dec_folder'"
    
      if [ "$register_in_conf_dotfile" = "true" ] ; then
         if [ -f "$unidec_conf_dotfile" ] ; then
            local unidec_entry=$(grep $unidec_token $unidec_conf_dotfile)

            if [ -n "$unidec_entry" ] ; then
               [ "$unidec_folder" = "$unidec_entry" ] || die "Err: different unidec with the same decimal ('$unidec_folder' vs. '$unidec_entry')"
            else
               echo $unidec_folder >> $unidec_conf_dotfile
               echo "OK: written this unidec ('$unidec_folder') to $unidec_conf_dotfile"
            fi
         fi
       fi
   fi
}




init_dirs 

if [ -f "$unidec_conf_file" ] ; then
  # loop through
   link_conf_entries
else
  xdec_path=$(pwd)
  link_path "$xdec_path" 'true'
fi


