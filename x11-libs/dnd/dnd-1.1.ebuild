# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/dnd/dnd-1.1.ebuild,v 1.20 2005/02/16 07:24:58 pclouds Exp $

inherit eutils

S=${WORKDIR}/DND/DNDlib
DESCRIPTION="OffiX' Drag'n'drop library"
HOMEPAGE="http://leb.net/OffiX"
SRC_URI="http://leb.net/OffiX/dnd.1.1.tgz"
IUSE=""
SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 sparc alpha ia64 amd64 ppc ppc64"

DEPEND="virtual/x11"

src_unpack() {
	unpack dnd.1.1.tgz
	cd ${S}
	epatch ${FILESDIR}/${PF}-gentoo.diff || die
	epatch ${FILESDIR}/Makefile-fix.patch || die
}

src_compile() {
	econf --with-x || die
	emake || die
}

src_install () {
	make DESTDIR=${D} prefix=${D}/usr install || die
}
