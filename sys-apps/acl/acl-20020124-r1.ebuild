# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/acl/acl-20020124-r1.ebuild,v 1.1 2002/03/05 02:52:01 woodchip Exp $

S=${WORKDIR}/cmd/${PN}
DESCRIPTION="XFS dump/restore utilities"
SRC_URI="http://www.ibiblio.org/gentoo/distfiles/xfs-cmd-${PV}.tar.bz2"
HOMEPAGE="http://oss.sgi.com/projects/xfs"

DEPEND="virtual/glibc sys-devel/autoconf sys-devel/make"
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
	make DESTDIR=${D} install || die

	# basically do the install-dev target by hand...
	insinto /usr/include/sys ; doins include/acl.h
	insinto /usr/include/acl ; doins include/libacl.h
	insinto /usr/lib
	doins libacl/libacl.la
	doins libacl/.libs/libacl.a
	cd ${D}/lib
	chmod 755 libacl.so.1.0.0
	ln -s libacl.so.1.0.0 libacl.so

	# fixie
	cd ${D}/usr/share/doc
	mv ${PN} ${PF}
}
