CURL ?= curl
FONTFORGE ?= fontforge
UNZIP ?= unzip
ZIP ?= zip

FPFLAGS = --complete \
					--quiet \
					--no-progressbars

font-patcher-dir := fp
font-patcher := $(font-patcher-dir)/font-patcher
font-patcher-archive := FontPatcher.zip
build-dir := build

srcfontsdir := /Library/Fonts
src := $(wildcard $(srcfontsdir)/SF-Mono-*)
srcfonts := $(notdir $(src))

fontsdir := fonts
fonts := $(notdir $(src))
fonts := $(join $(addsuffix -Nerd-Font-Complete,$(basename $(fonts))),$(suffix $(fonts)))
fonts := $(addprefix $(fontsdir)/,$(fonts))

all: $(fonts)

.PHONY: install
install: $(fonts)
	cp $^ ~/Library/Fonts/

.PHONY: check
check: codicon.csv
	cat $<

$(fonts): $(fontsdir)/%-Nerd-Font-Complete.otf: $(srcfontsdir)/%.otf | $(fontsdir)
	$(FONTFORGE) -script $(font-patcher) --outputdir $(build-dir)/$* $(FPFLAGS) $<
	mv $(build-dir)/$*/* $@

$(fontsdir):
	mkdir $(fontsdir)

$(font-patcher): $(font-patcher-archive)
	$(UNZIP) $< -d $(font-patcher-dir)

$(font-patcher-archive):
	$(CURL) -sL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FontPatcher.zip -o $@

codicon.csv:
	$(CURL) -sL https://raw.githubusercontent.com/microsoft/vscode-codicons/main/dist/codicon.csv -o $@

print-%: ; @echo $*=$($*)
