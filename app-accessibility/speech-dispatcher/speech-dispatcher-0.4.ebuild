# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/speech-dispatcher/speech-dispatcher-0.4.ebuild,v 1.1 2004/05/28 20:57:44 squinky86 Exp $

DESCRIPTION="speech-dispatcher speech synthesis interface"
HOMEPAGE="http://www.freebsoft.org/speechd"
SRC_URI="http://www.freebsoft.org/pub/projects/speechd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND="dev-libs/dotconf
	>=app-accessibility/flite-1.2
	>=dev-libs/glib-2
	media-libs/alsa-lib"

src_install() {
	make DESTDIR=${D} install || die

	exeinto /etc/init.d
	doexe ${FILESDIR}/speech-dispatcher

	insinto /usr/include
	doins ${S}/src/c/api/libspeechd.h
}

pkg_postinst() {
	echo
	einfo "To enable Festival support, you must install app-accessibility/festival-freebsoft-utils."
	echo
}
