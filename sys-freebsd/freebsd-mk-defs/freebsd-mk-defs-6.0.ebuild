# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-freebsd/freebsd-mk-defs/freebsd-mk-defs-6.0.ebuild,v 1.1 2006/04/01 16:43:51 flameeyes Exp $

inherit bsdmk freebsd

DESCRIPTION="Makefiles definitions used for building and installing libraries and system files"
SLOT="0"
KEYWORDS="~x86-fbsd"

IUSE=""

SRC_URI="mirror://gentoo/${SHARE}.tar.bz2"

RDEPEND=""
DEPEND=""

RESTRICT="nostrip"

S="${WORKDIR}/share/mk"

src_unpack() {
	unpack ${A}
	cd ${WORKDIR}/share
	epatch "${FILESDIR}/${PN}-${RV}-gentoo.patch"
	epatch "${FILESDIR}/${PN}-flex.patch"
	epatch "${FILESDIR}/${PN}-${RV}-strip.patch"
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	insinto /usr/share/mk
	doins *.mk
}
