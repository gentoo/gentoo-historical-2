# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/opera/opera-8.00_beta2.ebuild,v 1.1 2005/03/02 11:25:40 lanius Exp $

IUSE="static spell"

OPERAVER="8.0-20050225"
OPERAFTPDIR="800b2/beta/en"

S=${WORKDIR}/${A/.tar.bz2/}

DESCRIPTION="Opera web browser."
HOMEPAGE="http://www.opera.com/linux/"

# that's an ugly workaround for the broken src_uri syntax
OPERA_URI="ftp://ftp.opera.com/pub/opera/linux/${OPERAFTPDIR}/"
SRC_URI="
	x86? ( static? ( ${OPERA_URI}/i386/static/${PN}-${OPERAVER}.1-static-qt.i386-en.tar.bz2 ) )
	x86? ( !static? ( ${OPERA_URI}/i386/${PN}-${OPERAVER}.5-shared-qt.i386-en.tar.bz2 ) )
	amd64? ( ${OPERA_URI}/i386/static/${PN}-${OPERAVER}.1-static-qt.i386-en.tar.bz2 )
	sparc? ( static? ( ${OPERA_URI}/sparc/static/${PN}-${OPERAVER}.1-static-qt.sparc-en.tar.bz2 ) )
	ppc? ( ${OPERA_URI}/ppc/static/${PN}-${OPERAVER}.1-static-qt.ppc-en.tar.bz2 )"

#	sparc? ( !static? ( ${OPERA_URI}/sparc/${PN}-${OPERAVER}.2-shared-qt.sparc-en.tar.bz2 ) )
#	amd64? ( !static? ( ${OPERA_URI}/intel-linux/en/${PN}-${OPERAVER}.5-shared-qt.i386-en.tar.bz2 ) )
#	ppc? ( !static? ( ${OPERA_URI}/ppc-linux/en/${PN}-${OPERAVER}.3-shared-qt.ppc-en.tar.bz2 ) )

# Dependencies may be augmented later (see below).
DEPEND=">=sys-apps/sed-4
	amd64? ( sys-apps/linux32 )"

RDEPEND="virtual/x11
	>=media-libs/fontconfig-2.1.94-r1
	media-libs/libexif
	x11-libs/openmotif
	spell? ( app-text/aspell )
	amd64? ( static? ( app-emulation/emul-linux-x86-xlibs )
	         !static? ( =app-emulation/emul-linux-x86-qtlibs-1* ) )

	x86? ( !static? ( =x11-libs/qt-3* ) )"

SLOT="0"
LICENSE="OPERA"
KEYWORDS="~x86 ~ppc ~amd64"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "s:config_dir=\"/etc\":config_dir=\"${D}/etc/\":g" \
	       -e "s:/usr/share/applnk:${D}/usr/share/applnk:g" \
	       -e "s:/usr/share/pixmaps:${D}/usr/share/pixmaps:g" \
	       -e "s:/usr/share/icons:${D}/usr/share/icons:g" \
	       -e "s:/etc/X11:${D}/etc/X11:g" \
	       -e "s:/usr/share/gnome:${D}/usr/share/gnome:g" \
	       -e 's:#\(OPERA_FORCE_JAVA_ENABLED=\):\1:' \
	       -e 's:#\(export LD_PRELOAD OPERA_FORCE_JAVA_ENABLED\):\1:' \
		   -e 's:read str_answer:return 0:' \
		   -e "s:/opt/kde:${D}/usr/kde:" \
		   -e "s:\(str_localdirplugin=\).*$:\1/opt/opera/lib/opera/plugins:" \
	       install.sh || die
}

src_compile() {
	true
}

src_install() {
	# Prepare installation directories for Opera's installer script.
	dodir /etc

	# Opera's native installer.
	if [ ${ARCH} = "amd64" ]; then
		linux32 ./install.sh --prefix="${D}"/opt/opera || die
	else
		./install.sh --prefix="${D}"/opt/opera || die
	fi

	# java workaround
	sed -i -e 's:LD_PRELOAD="${OPERA_JAVA_DIR}/libawt.so":LD_PRELOAD="$LD_PRELOAD"\:"${OPERA_JAVA_DIR}/libawt.so":' ${D}/opt/opera/bin/opera

	dosed /opt/opera/bin/opera
	dosed /opt/opera/share/opera/java/opera.policy

	# Install the icons
	insinto /usr/share/pixmaps
	doins images/opera.xpm

	# Install the menu entry
	insinto /usr/share/applications
	doins ${FILESDIR}/opera.desktop

	# Install a symlink /usr/bin/opera
	dodir /usr/bin
	dosym /opt/opera/bin/opera /usr/bin/opera

	# fix plugin path
	echo "Plugin Path=/opt/opera/lib/opera/plugins" >> ${D}/etc/opera6rc

	# enable spellcheck
	if use spell; then
		if use static; then
			DIR=$OPERAVER.1
		else
			use sparc && DIR=$OPERAVER.2 || DIR=$OPERAVER.5
		fi
		echo "Spell Check Engine=/opt/opera/lib/opera/${DIR}/spellcheck.so" >> ${D}/opt/opera/share/opera/ini/spellcheck.ini
	fi
}

pkg_postinst() {
	einfo "For localized language files take a look at:"
	einfo "http://www.opera.com/download/languagefiles/index.dml?platform=linux"
	einfo
	einfo "To change the spellcheck language edit /opt/opera/share/opera/ini/spellcheck.ini"
	einfo "and emerge app-text/aspell-language."
}
