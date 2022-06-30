mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir_path := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
build_dir_path := $(mkfile_dir_path)/build
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
BLD := $(mkfile_dir_path)/build

VOC = voc
VERSION_FILE = ./VersionFile.json
BLD = build
DPS = dps
VIPACK = vipack


all: deps

	#git submodule init
	#git submodule update
	mkdir -p $(build_dir_path)
	cd $(build_dir_path)
	gmake -f $(mkfile_dir_path)/dps/lists/Makefile BUILD=$(build_dir_path)
	gmake -f $(mkfile_dir_path)/dps/Internet/makefile BUILD=$(build_dir_path)
	gmake -f $(mkfile_dir_path)/dps/time/Makefile BUILD=$(build_dir_path)
	gmake -f $(mkfile_dir_path)/dps/opts/Makefile BUILD=$(build_dir_path)
	cd $(build_dir_path) && \
	$(VOC) -s \
		../src/vpkSettings.Mod \
		../src/unix/vpkLinuxFiles.Mod \
		../src/unix/vpkTime.Mod \
		../src/vpkLogger.Mod \
		../src/vpkHttp.Mod \
		../src/unix/vpkEnv.Mod \
		../src/unix/vpkGit.Mod \
		../src/vpkCharacterStack.Mod \
		../src/vpkJsonParser.Mod \
	  ../src/vpkConf.Mod \
		../src/vpkStorage.Mod \
	  ../src/vpkSyncer.Mod \
		../src/vpkdepTree.Mod \
		../src/vpkDot.Mod \
		../src/vpkResolver.Mod \
		../src/vpkJsonDepRetriever.Mod \
		../src/vpkInstaller.Mod \
		../src/vipack.Mod -m

deps:
		mkdir -p $(mkfile_dir_path)/$(DPS)
		cd $(mkfile_dir_path)/$(DPS)
		if [ -d $(DPS)/Internet ]; then cd $(DPS)/Internet; git pull; cd -; else cd $(DPS); git clone https://github.com/norayr/Internet; cd -; fi
		if [ -d $(DPS)/lists ]; then cd $(DPS)/lists; git pull; cd -; else cd $(DPS); git clone https://github.com/norayr/lists; cd -; fi
		if [ -d $(DPS)/opts ]; then cd $(DPS)/opts; git pull; cd -; else cd $(DPS); git clone https://github.com/norayr/opts; cd -; fi
		if [ -d $(DPS)/time ]; then cd $(DPS)/time; git pull; cd -; else cd $(DPS); git clone https://github.com/norayr/time; cd -; fi

tests:
			mkdir -p $(mkfile_dir_path)/$(BLD)
			cd $(mkfile_dir_path)/$(BLD)
			$(VOC) -s ../src/unix/vpkLinuxFiles.Mod ../tst/testFiles.Mod -m
			cd $(BLD) && $(VOC) -s ../src/vpkJsonParser.Mod ../tst/testJsonParser.Mod -m
			mkfifo /tmp/fifo
			$(BLD)/testFiles
			rm /tmp/fifo
			$(BLD)/testJsonParser

clean:
	if [ -d "$(BLD)" ]; then rm -rf $(BLD); fi
