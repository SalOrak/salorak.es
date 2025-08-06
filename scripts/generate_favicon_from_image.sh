output="./favicons"
expected_args=1

usage() {
    echo -e "\nDescription: Generates common size favicon images from an image"
    echo -e "\tUsage: $0 path/to/image"
    echo -e "\tOutput is stored in $output\n"
}


if [[ $# -ne $expected_args ]]; then
    echo "[ERROR]: Invalid number of arguments $#. Expected $expected_args argument"
    usage
    exit 1
fi

image_path=$1

# If file does not exist, return error
if [[ ! -f $image_path ]]; then
    echo "[ERROR]: File $image_path does not exists"
    usage
    exit 1
fi

generate_favicon(){
    # $1 image_path
    # $2 Size. The size of the image.
    if [[ $# -ne 2 ]]; then
        echo -e "[ERROR]: generate_favicon() expects 2 arguments but received $#."
        return 1
    fi

    original=$1
    size=$2
    imagename="favicon_${size}x${size}"
    result_favicon="$output/$imagename.svg"
    result_png="$output/$imagename.png"

    
    # If the file is an SVG, convert it to PNG so we can reescale it.
    if file --mime-type $original | grep -q 'image/svg+xml'; then
        temp_png="$output/original.png"
        inkscape $original --export-type=png --export-filename=$temp_png
        original=$temp_png
    fi


    # Create resized PNG image to desired size even if the image is not square.
    magick $original -resize "${size}x${size}" -background none -gravity center -compose Copy -extent "${size}x${size}" $result_png

    echo -e "[INFO]: Generating favicon $size x $size..."
    inkscape $result_png --export-area-drawing --export-width=$size --export-height=$size --export-type=svg --export-filename=$result_favicon
    echo -e "[INFO]: Successfully generated favicon with name: $result_favicon"
}


# Create the directories in case they don't exist
mkdir -p $output

# Favicon sizes to generate automatically
favicon_sizes=('16'  '32'  '48' '76' '96')

# Iterate over the favicon sizes and generate them
for fav in "${favicon_sizes[@]}"; do
    generate_favicon $image_path $fav
done

exit 0


# First let's get information about the image

# 16x16: The most common favicon 
# convert input.jpg -resize 800x600\! output.jpg
# 32x32: For higher resolution
# convert input.jpg -resize 800x600\! output.jpg

