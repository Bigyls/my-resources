log() {
    level="$1"
    shift
    case "$level" in
        "START") echo "[START] [$(date +'%F %T')] [BIGYLS MY-RESOURCES] $*" ;;
        "SUCCESS") echo "[SUCCESS] [$(date +'%F %T')] [BIGYLS MY-RESOURCES] $*" ;;
        "ERROR") echo "[ERROR] [$(date +'%F %T')] [BIGYLS MY-RESOURCES] $*" >&2 ;;
        "END") echo "[END] [$(date +'%F %T')] [BIGYLS MY-RESOURCES] $*" ;;
        *) echo "[INFO] [$(date +'%F %T')] [BIGYLS MY-RESOURCES] $*" ;;
    esac
}
