# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xtrlock/xtrlock-2.0.ebuild,v 1.3 2004/05/01 03:06:58 puggy Exp $

MY_P=${P/-/_}-6
DESCRIPTION="A simplistic screen locking program for X"
SRC_URI="mirror://debian/dists/potato/main/source/x11/${MY_P}.tar.gz"
HOMEPAGE="ftp://ftp.debian.org/debian/dists/stable/main/source/x11/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"

DEPEND="virtual/x11"

src_compile() {
	xmkmf || die
	cp Makefile Makefile.orig
	make CFLAGS="${CFLAGS} -DSHADOW_PWD" xtrlock || die
}

src_install() {
	dobin xtrlock
	chmod u+s ${D}/usr/bin/xtrlock
	mv xtrlock.man xtrlock.1
	doman xtrlock.1
}
