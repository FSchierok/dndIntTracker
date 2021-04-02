all: dndInitTracker.apk

dndInitTracker.apk: dnd_init_tracker/*
	cd dnd_init_tracker; flutter build apk --target-platform android-arm64
	mv dnd_init_tracker/build/app/outputs/flutter-apk/app-release.apk dndInitTracker.apk