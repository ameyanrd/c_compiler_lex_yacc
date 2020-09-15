CC := gcc
SRCDIR := src
BUILDDIR := build
TARGET := bin/scanner
TARGET_DIR := bin

SRCEXT := c
SOURCES := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))
INC := -I include

$(TARGET): $(OBJECTS)
	@echo " Linking..."
	@mkdir -p $(TARGET_DIR)
	@echo " $(CC) $^ -o $(TARGET) $(LIB)"; $(CC) $^ -o $(TARGET) $(LIB)

$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@echo " Compiling..."
	@echo " $(OBJECTS)"
	@mkdir -p $(BUILDDIR)
	@echo " $(CC) $(INC) -c -o $@ $<"; $(CC) $(INC) -c -o $@ $<

clean:
	@echo " Cleaning..."; 
	@echo " $(RM) -r $(BUILDDIR) $(TARGET)"; $(RM) -r $(BUILDDIR) $(TARGET)

configure: $(SRCDIR)
	@bash configure.sh

test: $(TARGET)
	@bash test.sh

.PHONY: clean
