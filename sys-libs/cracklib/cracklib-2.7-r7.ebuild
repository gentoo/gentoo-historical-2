# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/cracklib/cracklib-2.7-r7.ebuild,v 1.23 2004/05/12 13:18:31 pappy Exp $

inherit flag-o-matic eutils

MY_P=${P/-/,}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Password Checking Library"
HOMEPAGE="http://www.crypticide.org/users/alecm/"
SRC_URI="http://www.crypticide.org/users/alecm/security/${MY_P}.tar.gz"

LICENSE="CRACKLIB"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha mips hppa amd64 ia64"

RDEPEND="sys-apps/miscfiles
	>=sys-apps/portage-2.0.47-r10"
DEPEND="${RDEPEND}
	sys-devel/gcc-config"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-redhat.patch
	epatch ${FILESDIR}/${P}-gentoo-new.diff
	[ "$ARCH" == "alpha" -a "${CC}" == "ccc" ] && \
		epatch ${FILESDIR}/cracklib-${PV}-dec-alpha-compiler.diff
}

src_compile() {
	# filter-flags -fstack-protector
	# Parallel make does not work for 2.7
	make all || die
}

src_install() {
	dodir /usr/{lib,sbin,include}
	keepdir /usr/share/cracklib

	make DESTDIR=${D} install || die

	# This link is needed and not created. :| bug #9611
	cd ${D}/usr/lib
	dosym libcrack.so.2.7 /usr/lib/libcrack.so.2
	cd ${S}

	cp ${S}/cracklib/packer.h ${D}/usr/include
	#fix the permissions on it as they may be wrong in some cases
	fperms 644 usr/include/packer.h

	preplib /usr/lib

	dodoc HISTORY LICENCE MANIFEST POSTER README
}
