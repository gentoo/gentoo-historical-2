# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/speech-dispatcher/speech-dispatcher-0.3.ebuild,v 1.7 2007/04/28 16:22:15 swegener Exp $

inherit eutils libtool

DESCRIPTION="speech-dispatcher speech synthesis interface"
HOMEPAGE="http://www.freebsoft.org/speechd"
SRC_URI="http://www.freebsoft.org/pub/projects/speechd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE=""

RDEPEND="dev-libs/dotconf
	>=app-accessibility/flite-1.2
	>=dev-libs/glib-2
	media-libs/alsa-lib"

DEPEND="${RDEPEND}
	>=sys-devel/automake-1.7.8
	>=sys-devel/autoconf-2.58"

src_unpack() {
	unpack ${A}

	cd ${S}
	export WANT_AUTOMAKE=1.7
	export WANT_AUTOCONF=2.5

	epatch ${FILESDIR}/${P}-gentoo.patch
	aclocal || die "aclocal failed"
	autoconf || die "autoconf failed"
	autoheader || die "autoheader failed"
	automake -a || die "automake -a failed"
	automake || die "automake failed"
	elibtoolize
}

src_install() {
	make DESTDIR=${D} install || die

	mv ${D}/usr/bin/speechd ${D}/usr/bin/speech-dispatcher

	doinitd ${FILESDIR}/speech-dispatcher

	insinto /usr/include
	doins ${S}/src/c/api/libspeechd.h
}

pkg_postinst() {
	elog
	elog "To enable Festival support, you must install app-accessibility/festival-freebsoft-utils."
	elog
}
