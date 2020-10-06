#!/bin/bash
theEndBase=false;
base="$HOME/Documents/Notes/checklists"
while [[ $theEndBase == false ]]; do
	file="`ls $base | dmenu -i -l 100 `"
	contentBase=`ls $base`

	if [ -z $file ]; then
		theEndBase=true;
		echo "`basename -- "$0"` closed."
	elif [[ $file == *" --remove"* ]]; then
		rm "$base/${file: 0:-9}"
		echo "File \"${file: 0:-9}\" removed."
	elif [[ $contentBase =~ $file ]]; then
		echo "File \"$file\" opened."
		theEndFile=false;
		while [[ $theEndFile == false ]]; do
			item="`cat "$base/$file" | dmenu -i -l 100 `"

			if [ -z "$item" ]; then
				theEndFile=true;
				echo "File \"$file\" closed."
			elif [[ "${item: 0:3}" == 'rn ' ]]; then
				mv "$base/$file" "$base/${item: 3}"
				echo "File \"$base/$file\" renamed o \"$base/${item: 3}\"."
				file="${item: 3}"
			elif grep -q "$item" "$base/$file"; then
				sed -i "/$item/d" "$base/$file"
				echo "Item \"$item\" removed."
			else
				if [[ "${item: -1}" != '.' ]]; then
					item="$item."
				fi
				echo $item  >> "$base/$file"
				echo "Item \"$item\" added."
			fi
		done
	else
		if [[ $file != *"."* ]]; then
			file="$file.txt"
		fi

		echo "File \"'$file'\" added."
		touch "$base/$file"
	fi

done
