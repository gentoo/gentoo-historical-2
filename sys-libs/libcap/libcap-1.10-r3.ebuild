# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libcap/libcap-1.10-r3.ebuild,v 1.15 2004/10/01 14:35:52 blubb Exp $

inherit flag-o-matic eutils

DEB_PVER=12
DESCRIPTION="POSIX 1003.1e capabilities"
HOMEPAGE="http://www.kernel.org/pub/linux/libs/security/linux-privs/"
SRC_URI="http://www.kernel.org/pub/linux/libs/security/linux-privs/kernel-2.4/${P}.tar.bz2
	http://ftp.debian.org/debian/pool/main/libc/libcap/libcap_${PV}-${DEB_PVER}.diff.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha hppa amd64 ia64"
IUSE="python"

#patch is in recent 2.2 kernels so it works there
DEPEND="virtual/libc
	virtual/os-headers
	python? ( >=virtual/python-2.2.1 >=dev-lang/swig-1.3.10 )"
RDEPEND="python? ( >=virtual/python-2.2.1 )
	virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/libcap_${PV}-${DEB_PVER}.diff
	epatch ${FILESDIR}/${PV}-python.patch
	sed -i 's|WARNINGS=-ansi|WARNINGS=|' Make.Rules
}

src_compile() {
	local PYTHONVER="`python -V 2>&1 | sed 's/^Python //'|sed 's/\([0-9]*\.[0-9]*\).*/\1/'`"
	local myflags=""
	if use python ; then
		myflags="${myflags} PYTHON=1 PYTHONMODDIR=/usr/$(get_libdir)/python${PYTHONVER}/site-packages"
		append-flags -I/usr/include/python${PYTHONVER}
	fi

	use alpha && append-flags -fPIC
	use amd64 && append-flags -fPIC
	use hppa && append-flags -fPIC

	emake COPTFLAG="${CFLAGS}" DEBUG="" ${myflags} || die
}

src_install() {
	local PYTHONVER="`python -V 2>&1 | sed 's/^Python //'|sed 's/\([0-9]*\.[0-9]*\).*/\1/'`"
	local myflags=""
	if use python ; then
		myflags="${myflags} PYTHON=1 PYTHONMODDIR=${D}/usr/$(get_libdir)/python${PYTHONVER}/site-packages"
	fi
	make install FAKEROOT="${D}" man_prefix=/usr/share LIBDIR="${D}/$(get_libdir)" ${myflags} || die
	dodoc CHANGELOG README pgp.keys.asc doc/capability.notes
}
