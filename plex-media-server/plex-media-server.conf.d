# Config file for /etc/init.d/plex-media-server

PLEX_PIDFILE="/var/run/plex-media-server.pid"
PLEX_OUTLOG="/var/lib/plex/stdout.log"
PLEX_ERRLOG="/var/lib/plex/stderr.log"
PLEX_USER="plex"
PLEX_SCRIPT="/glibc/start_pms"

# the number of plugins that can run at the same time
export PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS=6

# ulimit -s $PLEX_MEDIA_SERVER_MAX_STACK_SIZE
export PLEX_MEDIA_SERVER_MAX_STACK_SIZE=3000

# where the mediaserver should store the transcodes
export PLEX_MEDIA_SERVER_TMPDIR=/tmp

# Plex runtime dir
export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR="/var/lib/plex"

