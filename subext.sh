#!/bin/bash


echo "Subtitle Extract!"


for file in *; do
    
    if [ -f "$file" ]; then
        extension="${file##*.}"

                video_name="${file%.*}"
                video_extention=""

        if [[ "$extension" == "mkv" || "$extension" == "mp4" ]]; then
            video_extention="$extension" 
            
            echo "$video_name.$video_extention"

            mapfile -t subtitle_list < <( ffmpeg -i "$video_name.$video_extention" 2>&1 | grep "Stream.*Subtitle" )
           
            for((i=0; i<${#subtitle_list[@]}; i++)); do
              subtitle_stream_name="${subtitle_list[i]}" 
              echo "$i - $subtitle_stream_name"

              subtitle_stream=$(echo "$subtitle_stream_name" | grep -oP '\d+:\d+\([a-zA-Z0-9]{3}\)')
              stream_value=$(echo "$subtitle_stream" | awk -F'[()]' '{print $1}')
              sub_language=$(echo "$subtitle_stream" | awk -F'[()]' '{print $2}')

              ffmpeg -i "$video_name.$video_extention" -map "$stream_value" "$video_name.$sub_language.srt" -y
          done  
        fi
    fi
  done
