clean:
	flutter clean
	flutter pub get
	@make build-runner

# Run App
run:
	flutter run
run-profile:
	flutter run --profile
run-release:
	flutter run --release

# Format, Lint and Test
format:
	flutter format . --line-length 120 --set-exit-if-changed
format-fix:
	flutter format . --line-length 120
lint:
	flutter analyze
test:
	flutter test
.PHONY: test


# Build runner
build-runner:
	flutter pub run build_runner build --delete-conflicting-outputs
build-runner-watch:
	flutter pub run build_runner watch --delete-conflicting-outputs

# Build Platforms
build-ios:
	@echo "Build iOS"
	make clean
	rm -rf ios/dist
	# flutter build ipa --tree-shake-icons --export-options-plist=ios/ios-export-options.plist --analyze-size --suppress-analytics
	flutter build ipa --obfuscate --split-debug-info=./dist/debug/ --tree-shake-icons --export-options-plist=ios/ios-export-options.plist --suppress-analytics
	cp build/ios/ipa/app.ipa dist/app.ipa
build-android-apk:
	@echo "Build APK's"
	make clean
	# flutter build apk --target-platform=android-arm64 --analyze-size
	flutter build apk --target-platform=android-arm,android-arm64 --obfuscate --split-debug-info=./dist/debug/
	cp build/app/outputs/apk/release/app-release.apk dist/
	mv dist/app-release.apk dist/app.apk
build-android-appbundle:
	@echo "Build Store App Bundle"
	make clean
	# flutter build appbundle --analyze-size
	flutter build appbundle --obfuscate --split-debug-info=./dist/debug/
	cp build/app/outputs/bundle/release/app-release.aab dist/
	mv dist/app-release.aab dist/app.aab
build-web:
	@echo "Build Web"
	make clean
	rm -rf dist/web
	flutter build web
	cp -r build/web dist/web

# Release Platforms
release-ios:
	@echo "Release iOS"
	cd ios; bundle exec fastlane deploy
release-android:
	@echo "Release Android"
	cd android; bundle exec fastlane deploy
release-web:
	@echo "Release Web"
	aws s3 sync build-output s3://samples.flutter.de --delete

# Additional helpers
packages-outdated:
	flutter pub outdated
packages-upgrade:
	flutter pub upgrade
l10n:
	flutter gen-l10n
splashscreen:
	flutter pub run flutter_native_splash:create
appicons:
	flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons.yaml
deeplink:
	@printf "Android:\nadb shell am start -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d 'app_web:///settings'"
	@printf "\n\n"
	@printf "iOS:\nxcrun simctl openurl booted app_web:///settings"
