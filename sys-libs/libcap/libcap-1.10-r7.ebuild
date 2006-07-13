# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libcap/libcap-1.10-r7.ebuild,v 1.2 2006/07/13 15:44:13 solar Exp $

inherit flag-o-matic eutils python toolchain-funcs

DEB_PVER="14"
DESCRIPTION="POSIX 1003.1e capabilities"
HOMEPAGE="http://www.kernel.org/pub/linux/libs/security/linux-privs/"
SRC_URI="http://www.kernel.org/pub/linux/libs/security/linux-privs/kernel-2.4/${P}.tar.bz2
		mirror://debian/pool/main/libc/libcap/libcap_${PV}-${DEB_PVER}.diff.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="nocxx python"

#patch is in recent 2.2 kernels so it works there
DEPEND="virtual/os-headers
		!nocxx? ( python? ( >=virtual/python-2.2.1
		                    >=dev-lang/swig-1.3.10 ) )"
RDEPEND="!nocxx? ( python? ( >=virtual/python-2.2.1 ) )"

src_unpack() {
	unpack "${P}.tar.bz2"
	cd "${S}"
	epatch "${DISTDIR}/libcap_${PV}-${DEB_PVER}.diff.gz"
	epatch "${FILESDIR}/${PV}-python.patch"
	epatch "${FILESDIR}/libcap-1.10-r4-staticfix.diff"
	sed -i.orig  \
		-e 's|WARNINGS=-ansi|WARNINGS=|' \
		-e 's|^LDFLAGS=-s.*|LDFLAGS = |' \
		-e '/^COPTFLAGS/d' \
		Make.Rules
}

src_compile() {
	local myflags=
	# -static is never should never be used on shared objects like a lib.
	#if use static; then
	#	append-flags -static
	#	append-ldflags -static
	#fi
	if ! tc-is-cross-compiler && ! use nocxx && use python ; then
		python_version
		myflags="${myflags} PYTHON=1 PYTHONMODDIR=/usr/$(get_libdir)/python${PYVER}/site-packages"
		append-flags "-I/usr/include/python${PYVER}"
	fi

	emake COPTFLAG="${CFLAGS}" LDFLAGS="${LDFLAGS}" ${myflags} || die
}

src_install() {
	into /
	dosbin progs/sucap progs/execcap progs/setpcaps progs/getpcaps
	dolib.so libcap/libcap.so.1.10
	gen_usr_ldscript libcap.so
	into /usr
	dolib.a libcap/libcap.a

	insinto /usr/include/sys
	doins libcap/include/sys/capability.h

	dodoc CHANGELOG README pgp.keys.asc doc/capability.notes capfaq-0.2.txt
	doman doc/*.3

	if ! tc-is-cross-compiler && ! use nocxx && use python ; then
		python_version
		local PYTHONMODDIR="/usr/$(get_libdir)/python${PYVER}/site-packages"
		exeinto "${PYTHONMODDIR}"
		doexe libcap/libcapmodule.so
		insinto "${PYTHONMODDIR}"
		doins libcap/libcap.py
	fi
}
