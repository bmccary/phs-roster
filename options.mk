
# These are options that can be overridden with local.mk
# or at the command line, e.g.
#
# 	make PYTHON=python2 PREFIX=something-less-dramatic
#
# The order of precedence is options.mk < local.mk < command line,
# with greatest being the one used.
#
# You probably shouldn't edit this file b/c it is included
# in the repo.

# The directory that files will be put into
BUILD := build

# Set to non-blank to make XLSX rosters
MAKE_XLSX := that-would-be-great

# Set to non-blank to make PDF rosters
MAKE_PDF := this-would-be-great-too

# pdfimages makes files with pattern $(PREFIX)-%03d.ppm
# and the hyphen is included even if $(PREFIX) is empty.
# Any \w+ will do.
PREFIX := pdfimages-has-a-bad-ui-and-that-makes-me-sad

# Used when manually fixing mis-detected NetID <-> Image (rare).
PDF_VIEWER := evince

# Used when manually fixing mis-detected NetID <-> Image (rare).
IMAGE_VIEWER := display

# Used when manually fixing mis-detected NetID <-> Image (rare).
# 	YESNO = YESNO_TRUE skip the verification.
# 	YESNO = YESNO_ZENITY will use a zenity pop-up for verification.
# 	YESNO = YESNO_DIALOG will use a dialog (in the terminal) for verification.
YESNO_ZENITY = zenity --question --text='Is it $(1)?'
YESNO_DIALOG = dialog --title 'Feed me, human!' --yesno 'Is it $(1)?' 8 60
YESNO_TRUE = true

YESNO = YESNO_TRUE

PYTHON := python3

# Set to non-blank if you want to be notified when
# there is more than one image for a given NetID.
NOTIFY_MULTIPLE :=

# When the image is converted to PNG, this will be
# it's height (aspect ratio preserved).
IMAGE_CONVERT_HEIGHT := 250

# Images in worksheets do no automatically resize to
# fit within the cell to which they are anchored, so
# we've got to set the row and column sizes for these
# cells manually. Further, I haven't figured out what
# coordinate system the spreadsheet uses, so these
# values are discovered by hand.
WORKSHEET_IMAGE_ROW_HEIGHT := 190
WORKSHEET_IMAGE_COL_WIDTH := 22

# Add --flipLR to flip left-to-right.
# Add --flipTB to flip top-to-bottom.
# Blank means nothing. E.g.,
# FLIP := --flipTB --flipLR
FLIP := --flipTB

# The orientation of the page. Only applies to TeX/PDF.
# May be landscape or portrait.
ORIENTATION := landscape

