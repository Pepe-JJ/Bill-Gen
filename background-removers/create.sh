#!/bin/bash

echo "photobear.io" | cowsay
cd photobear.io && bash web.sh

echo "rembg" | cowsay
# cd ../rembg && bash models.sh

echo "removal.ai" | cowsay
cd ../removal.ai && bash web.sh

echo "transparent-background" | cowsay
cd ../transparent-background && bash models.sh
