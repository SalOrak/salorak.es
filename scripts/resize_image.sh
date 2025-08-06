set -o errexit    # Used to exit upon error, avoiding cascading errors

expected_args=2

usage() {
    echo -e "\nDescription: Resizes image to desired size"
    echo -e "\tUsage: $0 path/to/image size"
    echo -e "\tExample: $0 ../images/logo.png 32   <-- Resizes image to 32x32 PNG" 
}


if [[ $# -ne $expected_args ]]; then
    echo "[ERROR]: Invalid number of arguments $#. Expected $expected_args argument"
    usage
    exit 1
fi

image_path=$1
new_size=$2

# If file does not exist, return error
if [[ ! -f $image_path ]]; then
    echo "[ERROR]: File $image_path does not exists"
    usage
    exit 1
fi

resize_image(){
    # $1 image_path
    # $2 Size. The size of the image.
    if [[ $# -ne 2 ]]; then
        echo -e "[ERROR]: generate_favicon() expects 2 arguments but received $#."
        return 1
    fi

    original=$1
    size=$2
    imagename="${original%.*}_${size}x${size}.png"
    result="$imagename"

    
    temp_png="$(date +%Y%m%d%H%M%S).png"
    # If the file is an SVG, convert it to PNG so we can reescale it.
    if file --mime-type $original | grep -q 'image/svg+xml'; then
        inkscape $original --export-type=png --export-filename=$temp_png
        original=$temp_png
    fi


    echo -e "[INFO]: Resizng image to ${size}x${size}..."
    # Create resized PNG image to desired size even if the image is not square.
    magick $original -resize "${size}x${size}" -background none -gravity center -compose Copy -extent "${size}x${size}" $result
    echo -e "[INFO]: Successfully resized image to ${size}x${size}: $result"

    if [[ -f $temp_png ]]; then 
        rm $temp_png
    fi
}

resize_image $image_path $new_size

exit 0
