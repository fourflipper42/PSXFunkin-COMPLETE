.PHONY: setup build check play shell clean distclean

setup:
	./dev.sh setup --fetch-psyq

build:
	./dev.sh build

check:
	./check.sh

play:
	./play.sh

shell:
	./dev.sh bash

clean:
	rm -rf build out

distclean:
	rm -rf build out upstream official-v084 official-assets psx-week-reference .deps
