# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/opera/opera-6.11-r1.ebuild,v 1.2 2003/02/13 15:40:50 vapier Exp $
#
# By default, the statically linked version of opera will be
# installed.  There are two other variations of the package that this
# ebuild can install.  To pick one, set OPERA_VARIANT environment
# variable to one of the following:
#
# 1. static-2.95  # Statically linked libraries, compiled with gcc 2.95.
#		  # (Default)
# 2. shared-2.95  # Dynamically linked libaries, compiled with gcc 2.95.
# 3. shared-3.2	  # Dynamically linked libraries, compiled with gcc 3.2.
#
# Note that the default variant should work for everybody, and is the
# least likely to cause you any grief.	Only change the variant if you
# know what you are doing.
#
# Example of compiling a non-default variant:
#
#   env OPERA_VARIANT=shared-3.2 emerge opera
#

DESCRIPTION="Opera web browser."
HOMEPAGE="http://www.opera.com/linux/"
LICENSE="OPERA"
IUSE="gnome kde"

# Dependencies may be augmented later (see below).
RDEPEND="virtual/x11"

KEYWORDS="x86"
SLOT="0"

case "${OPERA_VARIANT}" in
	shared-3.2)
	    RDEPEND="${RDEPEND} =x11-libs/qt-3*"
	    OPERA_VERSION="4-shared-qt"
	    URL_DIR="shared/gcc-3.2/"
	    ;;
	shared-2.95)
	    RDEPEND="${RDEPEND} =x11-libs/qt-3*"
	    OPERA_VERSION="2-shared-qt"
	    URL_DIR="shared/gcc-2.95/"
	    ;;
	*)
	    OPERA_VERSION="1-static-qt"
	    URL_DIR="static/"
	    ;;
esac

NV=6.11-20021129.${OPERA_VERSION}.i386
SRC_URI="http://www.panix.com/opera/files/linux/611/final/en/i386/${URL_DIR}/opera-${NV}.tar.gz"
S=${WORKDIR}/opera-${NV}


src_unpack() {

	unpack ${A}
	cd ${S}
	sed -e "s:/etc:${D}/etc:g" \
	    -e "s:config_dir=\"/etc\":config_dir=\"${D}/etc/\":g" \
	    -e "s:read install_config:install_config=yes:" \
	    -e "s:/opt/kde2:${D}/usr/kde/2:g" \
	    -e "s:/opt/kde2:${D}/usr/kde/2:g" \
	    -e "s:/usr/share/applnk:${D}/usr/share/applnk:g" \
	    -e "s:/usr/share/pixmaps:${D}/usr/share/pixmaps:g" \
	    -e "s:/usr/share/icons:${D}/usr/share/icons:g" \
	    -e "s:/etc/X11:${D}/etc/X11:g" \
	    -e "s:/usr/share/gnome:${D}/usr/share/gnome:g" \
	    -e 's:#\(LD_PRELOAD=.*libawt.so\):\1:' \
	    -e 's:#\(OPERA_FORCE_JAVA_ENABLED=\):\1:' \
	    -e 's:#\(export LD_PRELOAD OPERA_FORCE_JAVA_ENABLED\):\1:' \
	    < install.sh >install.sh.hacked || die
	mv install.sh.hacked install.sh
	chmod +x install.sh

}


src_compile() {
	# Nothing to compile.
	true
}


src_install() {

	# Prepare installation directories for Opera's installer script.
	dodir /etc
	if [ "`use kde`" ]
	then
		# Install stuff for KDE2, and then simply copy it over
		# into the KDE3 directories.
		dodir /usr/kde/2/share/icons/{locolor,hicolor}/{16x16,22x22,32x32,48x48}/apps
		dodir /usr/kde/2/share/applnk/Internet
	fi
	if [ "`use gnome`" ]
	then
		dodir /usr/share/gnome/pixmaps
		dodir /usr/share/gnome/apps/Internet
	fi

	# Opera's native installer.
	./install.sh --prefix="${D}"/opt/opera || die
	if [ "`use kde`" ]
	then
		cp -R ${D}/usr/kde/2 ${D}/usr/kde/3
	fi
	rm ${D}/opt/opera/share/doc/opera/help
	dosym /opt/share/doc/opera/help /opt/opera/share/opera/help

	dosed /opt/opera/bin/opera
	dosed /opt/opera/share/opera/java/opera.policy

	# Install the icons
	insinto /usr/share/icons /etc/X11/wmconfig /etc/X11/applnk/Internet \
		/usr/share/pixmaps
	doins images/opera.xpm
	
	# Install a symlink /usr/bin/opera
	dodir /usr/bin
	dosym /opt/opera/bin/opera /usr/bin/opera

}
