#!/bin/sh
MYPROFILE=default-1.0_rc6

#We really need to upgrade baselayout now that it's possible:
myBASELAYOUT=`cat /usr/portage/profiles/${MYPROFILE}/packages | grep -v '^#' | grep sys-apps/baselayout | sed 's:^\*::'`
myPORTAGE=`cat /usr/portage/profiles/${MYPROFILE}/packages | grep -v '^#' | grep sys-apps/portage | sed 's:^\*::'`
myGETTEXT=`cat /usr/portage/profiles/${MYPROFILE}/packages | grep -v '^#' | grep sys-devel/gettext | sed 's:^\*::'`
myBINUTILS=`cat /usr/portage/profiles/${MYPROFILE}/packages | grep -v '^#' | grep sys-devel/binutils | sed 's:^\*::'`
myGCC=`cat /usr/portage/profiles/${MYPROFILE}/packages | grep -v '^#' | grep sys-devel/gcc | sed 's:^\*::'`

echo "Using $myBASELAYOUT"
echo "Using $myPORTAGE"
echo "Using $myBINUTILS"
echo "Using $myGCC"
echo "Using $myGETTEXT"
echo "Using $myGLIBC"

cleanup() {
	cp /etc/make.conf.build /etc/make.conf
	exit $1
}

#USE may be set from the environment so we back it up for later.
export ORIGUSE="`spython -c 'import portage; print portage.settings["USE"];'`"
export USE="build"
#get correct CFLAGS, CHOST, CXXFLAGS, MAKEOPTS since make.conf will be
#overwritten
cp /etc/make.conf /etc/make.conf.build
export CFLAGS="`spython -c 'import portage; print portage.settings["CFLAGS"];'`"
export CHOST="`spython -c 'import portage; print portage.settings["CHOST"];'`"
export CXXFLAGS="`spython -c 'import portage; print portage.settings["CXXFLAGS"];'`"
export MAKEOPTS="`spython -c 'import portage; print portage.settings["MAKEOPTS"];'`"

export CONFIG_PROTECT=""
#above allows portage to overwrite stuff
cd /usr/portage
emerge $myPORTAGE #separate, so that the next command uses the *new* emerge
emerge $myBASELAYOUT $myBINUTILS $myGCC $myGETTEXT || cleanup 1
#make.conf has been overwritten, so we explicitly export our original settings
export USE="$ORIGUSE"
# This line should no longer be required
emerge $myGLIBC $myGETTEXT $myBINUTILS $myGCC || cleanup 1
#restore original make.conf
cleanup 0
