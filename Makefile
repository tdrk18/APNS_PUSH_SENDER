IMAGE_NAME := tdrk18/apns_push_sender

build:
	docker build -t ${IMAGE_NAME} .

clean:
	docker rmi ${IMAGE_NAME}

pull:
	docker pull ghcr.io/${IMAGE_NAME}:latest

run: build
	@if [ -z ${DEVICE_TOKEN} ]; then \
		echo "set DEVICE_TOKEN, please"; \
		exit 1; \
	elif [ -z ${BUNDLE_ID} ]; then \
		echo "set BUNDLE_ID, please"; \
		exit 1; \
	elif [ -z ${P12_PATH} ]; then \
		echo "set P12_PATH, please"; \
		exit 1; \
	elif [ -z ${PASSWORD} ]; then \
		echo "set PASSWORD for the p12 file, please"; \
		exit 1; \
	fi
	docker run --rm \
		-v ${P12_PATH}:/var/tmp/keys/aps_key.p12:ro \
		${IMAGE_NAME} \
		sh /var/tmp/send_push.sh \
		--token=${DEVICE_TOKEN} \
		--bundleID=${BUNDLE_ID} \
		--password=${PASSWORD}
