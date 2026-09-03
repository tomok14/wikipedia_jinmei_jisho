#!/usr/bin/bash
# dumpサイトからダンプを全てダウンロードする
# 2026年以降のexport複数ファイルバージョン

function get_latest_date() {
    local topurl="$1"
    topurl="${topurl%/}/"
    #echo "topurl=$topurl"
    local latest
    latest=$(curl -s "$topurl" | grep href | tail -1 | sed -r 's/^.*([0-9]{4}-[0-9]{2}-[0-9]{2}).*$/\1/')
    REPLY="$latest"
}
function get_arc_list() {
    local arcdir="$1"
    arcdir="${arcdir%/}/"
    local list
    list=$(curl -s "$arcdir" | grep bz2 | sed -r 's/^.*(jawiki-[0-9]{4}-[0-9]{2}-[0-9]{2}-p[0-9]+p[0-9]+\.xml\.bz2).*$/\1/')
    REPLY="$list"
}
function check_free_disk() {
    local avail
    avail=$(/usr/bin/df --output="avail" . | grep -E "[0-9]+")
    local human
    human=$(numfmt --to=iec $((avail * 1024)))
    human="${human}B"
    echo "disk avail=$avail($human)"

    # 10Gは必要
    if [ "$avail" -lt $((6 * 1024 * 1024)) ]; then
        echo "ERROR: no free space. avail=$human"
        exit 1
    fi
    return 0
}

function ntfy_notice() {
    subject="downarc.sh"
    body=""
    echo -e "$body" | curl --data-binary @- -H "Title:$subject done" https://oram.enia.net:8083/bk
}

#-----------------------------------------------------
function main() {
    # コマンドラインオプション
    local mode=1 # 0: orignal 1:mirror
    if [ "$1" = "-o" ]; then
        mode=0
    fi
    if [ "$1" = "-m" ]; then
        mode=1
    fi

    # 空き容量チェック
    check_free_disk

    local topurl_original="https://dumps.wikimedia.org/other/mediawiki_content_current/jawiki/"   # original
    local topurl_mirror="https://dumps.wikimedia.your.org/other/mediawiki_content_current/jawiki" # mirror
    local topurl

    if [ $mode -eq 0 ]; then
        echo "Download from [ORIGINAL]"
        topurl=$topurl_original
    else
        echo "Download from [mirror]"
        topurl=$topurl_mirror
    fi

    local latest
    latest=${|get_latest_date "$topurl";}
    echo "latest=$latest"

    local arcdir="${topurl}/${latest}/xml/bzip2"
    local list
    list=${|get_arc_list "$arcdir";}
    echo "LIST=[$list]"

    # すでにdownload済かどうかチェック
    for i in $list; do
        if [ -f "$i" ]; then
            printf '\033[1;33m⚠ WARN:\033[0m file exists: %s\n' "$i"
        fi
    done

    ## downloadするかどうかをユーザーに確認する
    #read -r -p "download? (y/N): " yn
    #case "$yn" in
    #[yY]*) echo "downloadします" ;;
    #*)
    #    echo "abort"
    #    exit 1
    #    ;;
    #esac

    for i in $list; do
        echo "i=$i"
        url="$arcdir/$i"
        echo "url=$url"
        wget -q "$url"
    done
}

main "$@"

# END OF FILE
