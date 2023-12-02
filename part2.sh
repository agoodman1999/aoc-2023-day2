

#read file contents into given array
# $1 file_path - path to file
# $2 array_name - array to read file into
read_file() {
	local file_path="$1"
  	local -n array_name="$2"
  	local line

	#read file into array
    IFS=$'\n'
    while IFS= read -r line || [ -n "$line" ]; do
		str=$(echo "$line" | tr -d '\r')
		str=$(echo "$str" | tr -d '\n')
        array_name+=("${str};")
    done < "$file_path"
}

#print array
# $1 array_name - array to print
print_array() {
  	local -n array_name="$1"
  	local line

  	for line in "${array_name[@]}"; do
		echo "$line"
  	done
}

#split string into array
# $1 str - string to split
# $2 array_name - array to store split string
split_string() {
	local str="$1"
	local -n array_name="$2"
	local delimiter="$3"
	local line

	IFS="$delimiter"
	for line in $str; do
		array_name+=("$line")
	done
}

regex_game='Game ([0-9]+):'
regex_color='([0-9]+) ([a-z]+)'

file_path="./input.txt"
file_lines=()

read_file "$file_path" file_lines
print_array file_lines

allowed_red_count=12
allowed_green_count=13
allowed_blue_count=14
minimum_power_sum=0

for line in "${file_lines[@]}"; do
	game_str="$line"

	#match game
	[[ $game_str =~ $regex_game ]]
	match="${BASH_REMATCH[0]}"
	game_number="${BASH_REMATCH[1]}"
	#echo ""
	#echo "game_str: $game_str"
	#echo "match_game: $match"
	#echo "game_number: $game_number"


	#remove game from string
	game_str="${game_str/$match/}"
	#echo "new_game_str: $game_str"

	#split strings into draw strings
	draws=()
	split_string "$game_str" draws ";"

	#echo ""
	#print_array draws

	#for each draw string
	largest_red_count=0
	largest_blue_count=0
	largest_green_count=0
	
	for draw in "${draws[@]}"; do
		#echo ""
		color_strings=()
		split_string "$draw" color_strings ","
		
		for color_string in "${color_strings[@]}"; do
			[[ $color_string =~ $regex_color ]]
			match="${BASH_REMATCH[0]}"
			color_number="${BASH_REMATCH[1]}"
			color_name="${BASH_REMATCH[2]}"
			#echo "color_name: $color_name, color_number: $color_number"

			if [[ "$color_name" == "red" ]]; then
				if [[ "$color_number" -gt "$largest_red_count" ]]; then
					largest_red_count="$color_number"
				fi
			elif [[ "$color_name" == "blue" ]]; then
				if [[ "$color_number" -gt "$largest_blue_count" ]]; then
					largest_blue_count="$color_number"
				fi
			elif [[ "$color_name" == "green" ]]; then
				if [[ "$color_number" -gt "$largest_green_count" ]]; then
					largest_green_count="$color_number"
				fi
			fi
		done
	done

	echo "largest_red_count: $largest_red_count"
	echo "largest_green_count: $largest_green_count"
	echo "largest_blue_count: $largest_blue_count"
	
	minimum_power=$((largest_red_count * largest_green_count * largest_blue_count))
	minimum_power_sum=$((minimum_power_sum + minimum_power))

	echo "minimum_power: $minimum_power"
	echo ""
done

echo ""
echo "minimum_power_sum: $minimum_power_sum"