#!/bin/sh

LNBASE=".$USER"
OUTDIR="$HOME"
TPLDIR="$OUTDIR/$LNBASE"

if [ "$(sed --version 2>&1 | cut -b 3)" = 'GNU' ]; then
	ESED='sed -r'
else
	ESED='sed -E'
fi

# Which files to ignore when copying over to $OUTDIR.
SEDCMD='s/^(\.git|\.gitignore|\.scy|dotfiles\.sh|res|[^/]{1,}\.(txt|ini|bat))$//'

# Formatted death.
die() {
	echo dotfiles.sh: "$1" >&2
	exit 1
}

cd "$TPLDIR" || die "could not change to template directory '$TPLDIR'"

echo 'Creating symlinks. Any following rm lines are for already existing files.'
echo 'These files will not be overwritten, but the rm line allows easy c&p deleting.'
echo 'You have to run dotfiles.sh again after deleting those files.'
find . -maxdepth 1 | cut -b 3- | $ESED -e "$SEDCMD" | while read ITEM; do
	if [ -n "$ITEM" ]; then
		LNTARGET="$LNBASE/$ITEM" # Where to link to.
		if [ -e "$OUTDIR/$ITEM" ]; then
			if [ ! -L "$OUTDIR/$ITEM" ]; then
				# If the destination already exists and is no symlink, skip it.
				echo rm -rf "$OUTDIR/$ITEM"
				continue
			else
				# If it _is_ a symlink, remove it, as we will re-link it now.
				rm "$OUTDIR/$ITEM"
			fi
		fi
		if [ -L "$ITEM" ]; then
			# If template is a symlink itself, copy instead of linking to link.
			cp -vPa "$ITEM" "$OUTDIR"
		else
			ln -vsf "$LNTARGET" "$OUTDIR/$ITEM"
		fi
	fi
done
