#!/usr/bin/env bash

SRVPORT=4499
RSPFILE=response

# Remove old response file and create a new FIFO
rm -f $RSPFILE
mkfifo $RSPFILE

# Function to handle incoming API requests
get_api() {
    read line
    echo $line
}

handleRequest() {
    # Get input and generate a fortune inside cowsay
    get_api
    mod=`/usr/games/fortune | /usr/games/cowsay`

cat <<EOF > $RSPFILE
HTTP/1.1 200

<pre>$mod</pre>
EOF
}

# Check that cowsay and fortune exist
prerequisites() {
    if ! command -v /usr/games/cowsay >/dev/null 2>&1; then
        echo "cowsay not installed!"
        exit 1
    fi
    if ! command -v /usr/games/fortune >/dev/null 2>&1; then
        echo "fortune not installed!"
        exit 1
    fi
}

# Main function to start the server
main() {
    prerequisites
    echo "Wisdom served on port=$SRVPORT..."

    while true; do
        # Listen on the port and handle requests
        cat $RSPFILE | nc -l -p $SRVPORT | handleRequest
        sleep 0.01
    done
}

# Start the application
main