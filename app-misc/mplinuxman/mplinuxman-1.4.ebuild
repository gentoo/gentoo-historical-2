# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mplinuxman/mplinuxman-1.4.ebuild,v 1.7 2004/11/05 08:18:16 eradicator Exp $

DESCRIPTION="A gtk2 frontend and drivers for mpman f50/55/60 mp3 players"
HOMEPAGE="http://mplinuxman.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-source-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="nls"

DEPEND=">=x11-libs/gtk+-2.2.4-r1
	>=sys-apps/sed-4
	nls? ( >=sys-devel/gettext-0.12.1 )"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A} && cd ${S} || die "unpack failed"
	sed -i -e "s,^CFLAGS = ,CFLAGS = ${CFLAGS} ," makefile
	sed -i -e "s,export LOCALE_DIR=/usr/local/share/locale,export LOCALE_DIR=${D}/usr/share/locale," makefile
	if ! use nls ; then
		sed -i -e "s,-D NLS=1,," makefile
	fi
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin mplinuxman || die "dobin failed"
	if use nls ; then
		dodir /usr/share/locale/es/LC_MESSAGES
		dodir /usr/share/locale/fr/LC_MESSAGES
		dodir /usr/share/locale/ja/LC_MESSAGES
		dodir /usr/share/locale/nl/LC_MESSAGES
		dodir /usr/share/locale/de/LC_MESSAGES
		DESTDIR="${D}" make install-po
	fi
	dodoc CHANGES README
}
