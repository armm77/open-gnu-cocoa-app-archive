#! /bin/sh
#
#	unwrap - extract the combined package (created with wrap)
#

# move the file to a new name with an extension
rm -rf $1.cvswrap
mv $1 $1.cvswrap

# untar the file

if `gzip -t -- $1.cvswrap > /dev/null 2>&1`
then
	gzcat -d -- $1.cvswrap | gnutar --preserve --sparse -x -f -
else
	gnutar --preserve --sparse -x -f $1.cvswrap
fi

# remove the original
rm -rf -- $1.cvswrap
