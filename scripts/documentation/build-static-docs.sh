#!/bin/bash

# builds with DocC and outputs to ./docs 
# with compatibliyt for static hosting, like
# while using Github pages
swift package --allow-writing-to-directory \
	./docs generate-documentation \
	--target SwiftCloudant \
	--output-path ./docs \
	--transform-for-static-hosting \
	--hosting-base-path swift-cloudant
