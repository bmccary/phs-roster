
# The directory that files will be put into
BUILD := build

# pdfimages makes files with pattern $(PREFIX)-%03d.ppm
# and the hyphen is included even if $(PREFIX) is empty.
# Any \w+ will do.
PREFIX := pdfimages-has-a-bad-ui-and-that-makes-me-sad

PDF_VIEWER := evince
IMAGE_VIEWER := display

# A command to cause a pop-up yes/no.
# dialog and zenity are both common, but zenity has
# the nice side-effect that because it causes a pop up
# (dialog works in the terminal), the mouse focus is
# more convenient.
YESNO_DIALOG = dialog --title 'Feed me, human!' --yesno 'Is it $(1)?' 8 60
YESNO_ZENITY = zenity --question --text='Is it $(1)?'
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

