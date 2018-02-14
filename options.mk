
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
YESNO = $(YESNO_ZENITY)

