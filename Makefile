run:
	flutter run

format: 
	flutter format . --line-length 120 --set-exit-if-changed

format-fix: 
	flutter format . --line-length 120

lint:
	flutter analyze

test:
	flutter test
.PHONY: test

packages-outdated:
	flutter pub outdated

packages-upgrade:
	flutter pub upgrade

clean:
	flutter clean
	flutter pub get

build-web:
	rm -rf build-output
	flutter build web --release
	cp -r build/web/. build-output

release-web:
	@echo "Release Web"
	aws s3 sync build-output s3://samples.flutter.de --delete
