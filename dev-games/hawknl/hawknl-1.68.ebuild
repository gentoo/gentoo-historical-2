# Copyright 1999-2004 Gentoo Technologies, Inc., 2004 Richard Garand <richard@garandnet.net>
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/hawknl/hawknl-1.68.ebuild,v 1.6 2004/04/28 09:03:45 mr_bones_ Exp $

inherit gcc

DESCRIPTION="A cross-platform network library designed for games"
HOMEPAGE="http://www.hawksoft.com/hawknl/"
SRC_URI="http://www.sonic.net/~philf/download/HawkNL${PV/./}src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ppc hppa amd64"
IUSE="doc"

DEPEND="virtual/glibc
	>=sys-apps/sed-4"

S=${WORKDIR}/hawknl${PV}

src_unpack() {
	unpack ${A}
	cd ${S}
	ln -s makefile.linux makefile

	sed -i \
		-e 's:make :$(MAKE) :g' makefile \
		|| die "sed makefile failed"

	sed -i \
		-e '/echo /d' src/makefile.linux \
		|| die "sed src/makefile.linux failed"
}

src_compile () {
	emake \
		CC="$(gcc-getCC)" \
		OPTFLAGS="${CFLAGS} -D_GNU_SOURCE -D_REENTRANT" || die "emake failed"
}

src_install () {
	local reallib

	dodir /usr/{include,lib}
	make install LIBDIR="${D}/usr/lib" INCDIR="${D}/usr/include" \
		|| die "make install failed"
	if [ `use doc` ] ; then
		docinto samples
		dodoc samples/* || die "dodoc failed"
	fi

	cd "${D}/usr/lib"
	for f in *.so* ; do
		[ ! -L ${f} ] && continue
		reallib="$(basename $(readlink NL.so))"
		ln -sf ${reallib} ${f}
	done
}
