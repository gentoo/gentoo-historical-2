# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dmapi/dmapi-20020124.ebuild,v 1.3 2002/07/10 16:17:57 aliz Exp $

S=${WORKDIR}/cmd/${PN}
DESCRIPTION="XFS data management API library"
SRC_URI="http://www.ibiblio.org/gentoo/distfiles/xfs-cmd-${PV}.tar.bz2"
HOMEPAGE="http://oss.sgi.com/projects/xfs"
LICENSE="LGPL-2.1 GPL-2"

DEPEND="virtual/glibc sys-devel/autoconf sys-devel/make sys-apps/xfsprogs"
RDEPEND="virtual/glibc"

src_compile() {
	cd ${S}
	export OPTIMIZER="${CFLAGS}"
	export DEBUG=-DNDEBUG
	autoconf || die
	./configure --prefix=/usr || die
	emake || die
}

src_install() {
	#let Steve Lord know that "install-dev" isn't mentioned in doc/INSTALL
	make DESTDIR=${D} install install-dev || die
	dosym /usr/lib/libdm.a /lib/libdm.a
	dosym /usr/lib/libdm.la /lib/libdm.la
	dosym /lib/libdm.so /usr/lib/libdm.so
}
