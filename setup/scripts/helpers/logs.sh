log() {
    level="$1"
    shift
    case "$level" in
        "START") echo "[START] [$(date +'%F %T')] $*" ;;
        "SUCCESS") echo "[SUCCESS] [$(date +'%F %T')] $*" ;;
        "ERROR") echo "[ERROR] [$(date +'%F %T')] $*" >&2 ;;
        "END") echo "[END] [$(date +'%F %T')] $*" ;;
        *) echo "[LOG] [$(date +'%F %T')] $*" ;;
    esac
} 