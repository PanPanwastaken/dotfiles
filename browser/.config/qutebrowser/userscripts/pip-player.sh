#!/bin/bash
# pip-player.sh - True PiP: capture video stream into chromeless popup window
# Uses captureStream() for video display
# Auto-shows on workspace change, hides when back on source workspace

APPID="miniplayer"
PIDFILE="/tmp/pip-monitor.pid"

# Reattach: if PiP exists, close it and stop monitor
if hyprctl clients -j | jq -e ".[] | select(.title | startswith(\"$APPID\"))" &>/dev/null; then
    hyprctl clients -j | jq -r ".[] | select(.title | startswith(\"$APPID\")) | .address" | \
        xargs -I{} hyprctl dispatch closewindow address:{}
    [[ -f "$PIDFILE" ]] && kill "$(cat "$PIDFILE")" 2>/dev/null && rm -f "$PIDFILE"
    echo "jseval --world=main (function(){var v=document.querySelector('video');if(v)v.play()})()" >> "$QUTE_FIFO"
    echo "message-info 'PiP: reattached'" >> "$QUTE_FIFO"
    exit 0
fi

read -r -d '' JS <<'JSEOF'
(function(){
  var v = document.querySelector('video');
  if (!v) { window.alert('No video element found'); return; }
  try {
    var stream = v.captureStream();
    var popup = window.open('', 'pip', 'width=480,height=270');
    if (!popup) { window.alert('Popup was blocked'); return; }
    popup.document.title = 'miniplayer';
    var d = popup.document;
    d.body.style.cssText = 'margin:0;padding:0;background:#000;overflow:hidden;position:relative';
    var pv = d.createElement('video');
    pv.srcObject = stream;
    pv.autoplay = true;
    pv.muted = true;
    pv.style.cssText = 'width:100vw;height:100vh;object-fit:contain';
    d.body.appendChild(pv);
    var sub = d.createElement('div');
    sub.style.cssText = 'position:fixed;bottom:8%;left:50%;transform:translateX(-50%);color:#fff;font-size:8px;font-family:sans-serif;text-align:center;text-shadow:0 0 2px #000,0 0 2px #000,1px 1px 1px #000;padding:2px 6px;border-radius:3px;background:rgba(0,0,0,0.6);z-index:10000;pointer-events:none;max-width:90%;display:none;line-height:1.2';
    d.body.appendChild(sub);
    function updateSub(){var segs=document.querySelectorAll('.ytp-caption-segment');if(segs.length>0){var txt='';segs.forEach(function(s){txt+=s.textContent+' '});txt=txt.trim();if(txt){sub.textContent=txt;sub.style.display='block';return}}sub.textContent='';sub.style.display='none'}
    var ytObs=new MutationObserver(updateSub);
    function startYtObs(){var cc=document.querySelector('.ytp-caption-window-container');if(cc){ytObs.observe(cc,{childList:true,subtree:true,characterData:true})}else{var player=document.querySelector('#movie_player')||document.querySelector('.html5-video-player');if(player){var waitObs=new MutationObserver(function(){var cc2=document.querySelector('.ytp-caption-window-container');if(cc2){waitObs.disconnect();ytObs.observe(cc2,{childList:true,subtree:true,characterData:true})}});waitObs.observe(player,{childList:true,subtree:true})}}}
    startYtObs();
    function watchTracks(){for(var i=0;i<v.textTracks.length;i++){(function(t){t.addEventListener('cuechange',function(){if(t.mode==='showing'&&t.activeCues&&t.activeCues.length>0){var txt='';for(var j=0;j<t.activeCues.length;j++){txt+=t.activeCues[j].text+' '}sub.textContent=txt.trim();sub.style.display='block'}else if(!document.querySelector('.ytp-caption-segment')){sub.textContent='';sub.style.display='none'}})})(v.textTracks[i])}}
    watchTracks();
    v.textTracks.addEventListener('addtrack',watchTracks);
    window._pipVideo = v;
    document.addEventListener('yt-navigate-finish', function(){setTimeout(function(){var nv=document.querySelector('video');if(nv&&popup&&!popup.closed){try{var ns=nv.captureStream();pv.srcObject=ns;pv.play().catch(function(){});window._pipVideo=nv;startYtObs();watchTracks()}catch(e){}}},1000)});
    window._pipWindow=popup;
  } catch(e) { window.alert('PiP error: ' + e.message); }
})()
JSEOF

SOURCE_WS=$(hyprctl activeworkspace -j | jq -r '.id')

# Hide bars before popup opens so miniplayer doesn't flash with bars
echo "set statusbar.show never" >> "$QUTE_FIFO"
echo "set tabs.show never" >> "$QUTE_FIFO"

# Popups open as separate windows
echo "set -t tabs.tabs_are_windows true" >> "$QUTE_FIFO"
# Temporarily allow popups so window.open() isn't blocked
echo "set -t content.javascript.can_open_tabs_automatically true" >> "$QUTE_FIFO"

echo "cmd-later 300 jseval --world=main ${JS//$'\n'/ }" >> "$QUTE_FIFO"

# Restore settings after popup opens
echo "cmd-later 3000 set -t tabs.tabs_are_windows false" >> "$QUTE_FIFO"
echo "cmd-later 3000 set -t content.javascript.can_open_tabs_automatically false" >> "$QUTE_FIFO"

echo "message-info 'PiP: extracting...'" >> "$QUTE_FIFO"

# Launch workspace monitor via hyprctl (ensures proper detach from userscript)
hyprctl dispatch exec "bash ~/.config/panscripts/pip-monitor.sh $SOURCE_WS"
