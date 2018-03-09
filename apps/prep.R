## SET WORKING DIRECTORY
# working dir = current file path
setwd(normalizePath("."))

library(tuber)

## AUTHENTICATION
## Manage API on https://console.developers.google.com/apis/credentials
app_id="find your own"
app_secret="find you own"
yt_oauth(app_id, app_secret, token="")

## COLECTING DOCS
channel_id = "UC4a-Gbdw7vOaccHmFo40b9g" # Khan
tgl = "2017-01-01"
videos = yt_search("computer+science"
	, channel_id=channel_id
	, video_caption="closedCaption"
	)
length(videos$video_id)

## CAPTIONING
coll = c()
for(vid in videos$video_id){
  # vid = as.character(res$video_id[i])
  cap_tracks = list_caption_tracks(video_id=vid,lang = "en")
  cap_id = as.character(cap_tracks$id[cap_tracks$language=="en"])[1]  # lang = "en" only
  caps = get_captions(id=cap_id)
  caps = as.character(caps)
  caps = paste(caps, sep="", collapse="")
  caps = sapply(seq(1, nchar(caps), by=2), function(x) substr(caps, x, x+1))
  caps = rawToChar(as.raw(strtoi(caps, 16L)))
  coll = c(coll,caps)
}

df = data.frame(videos$video_id,coll)
write.csv("data.csv", x=df) 

