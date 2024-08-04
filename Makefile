clean:
	flutter clean

get:
	flutter pub get

run:
	flutter run

build_runner:
	dart pub run build_runner build --delete-conflicting-outputs


all: clean get run
