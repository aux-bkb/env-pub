#set -g -x PKG_CONFIG_PATH
set -Ux  PKG_CONFIG_PATH

for dir in /opt/local/lib/pkgconfig /opt/local/share/pkgconfig /usr/local/lib/pkgconfig
  if [ -d "$dir" ] 
   set -Ux  PKG_CONFIG_PATH "$dir:$PKG_CONFIG_PATH"
  end
end
