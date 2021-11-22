IMAGE_NAME := tdrk18/apns_push_sender

build:
	docker build -t ${IMAGE_NAME} .

clean:
	docker rmi ${IMAGE_NAME}

run: build
	@if [ -z ${DEVICE_TOKEN} ]; then \
		echo "set DEVICE_TOKEN, please"; \
		exit 1; \
	elif [ -z ${BUNDLE_ID} ]; then \
		echo "set BUNDLE_ID, please"; \
		exit 1; \
	fi
	docker run --rm ${IMAGE_NAME} \
		sh /var/tmp/send_push.sh \
		--token=${DEVICE_TOKEN} \
		--bundleID=${BUNDLE_ID}
