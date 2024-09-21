#!/bin/bash

# Get the Github token and the Giphy API key from Github actions inputs
GITHUB_TOKEN=$1
GIPHY_API_KEY=$2

# Get the Pull Request number from the Github event Payload
pull_request_number=$(jq --raw-output .pull_request.number "GITHUB_EVENT_PATH")
echo PR Number - $pull_request_number

# Use the Giphy API to fetch a random Thank You GIF
giphy_reponse=$(curl -s "https://api.giphy.com/v1/gifs/random?api_key=$GIPHY_API_KEY&tag=thank%20you&rating=g")
echo Giphy Response - $giphy_reponse

# Extract the GIF URL from the Giphy response
gif_url=$(echo "$giphy_reponse" | jq --raw-output .data.images.downsized.url)
echo GIF URL - $gif_url

# Create a comment with the GIF on the Pull Request
comment_response=$(curl -sX POST -H "Authorization: token $GITHUB_TOKEN" \
                -H "Accept: application/vnd.github.v3+json" \
                -d "{\"body\": \ "### PR - #$pull_request_number. \n ### 🎉 Thank You For This Contribution! \n ![GIF]($gif_url) \"}"
                "https://github.com/repos/$GITHUB_REPOSITORY/issues/$pull_request_number/comments")

# Extract and Print the comment URL from the comment reponse
comment_url=$(echo "$comment_response" | jq --raw-output .html_url)

