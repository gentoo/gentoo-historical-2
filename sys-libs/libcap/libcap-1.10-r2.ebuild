# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libcap/libcap-1.10-r2.ebuild,v 1.1 2003/08/18 00:46:18 robbat2 Exp $

inherit base

DESCRIPTION="POSIX 1003.1e capabilities"
HOMEPAGE="http://linux.kernel.org/pub/linux/libs/security/linux-privs/"
SRC_URI="http://www.kernel.org/pub/linux/libs/security/linux-privs/kernel-2.4/${P}.tar.bz2"
LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~x86 ~arm ~mips ~hppa ~sparc ~ppc ~alpha"
IUSE="python"

#patch is in recent 2.2 kernels so it works there
DEPEND="virtual/glibc
        virtual/os-headers
        python? ( >=virtual/python-2.2.1 >=dev-lang/swig-1.3.10 )"
RDEPEND="python? ( >=virtual/python-2.2.1 )
		 virtual/glibc"

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/libcap-1.10-python.patch 
	sed -i 's|WARNINGS=-ansi|WARNINGS=|' Make.Rules
}

PYTHONVER="`python -V 2>&1 | sed 's/^Python //'|sed 's/\([0-9]*\.[0-9]*\).*/\1/'`"

src_compile() {
	local myflags
	myflags=""
	if use python; then
		myflags="${myflags} PYTHON=1 PYTHONMODDIR=/usr/lib/python${PYTHONVER}/site-packages" 
		CFLAGS="${CFLAGS} -I/usr/include/python${PYTHONVER}"
	fi
	
	# all 64 bit platforms need to get -fPIC
	use alpha || use mips && append-flags -fPIC
	
	emake COPTFLAG="${CFLAGS}" DEBUG="" ${myflags} || die
}

src_install() {
	local myflags
	myflags=""
	if use python; then
		myflags="${myflags} PYTHON=1 PYTHONMODDIR=${D}/usr/lib/python${PYTHONVER}/site-packages" 
	fi
	make install FAKEROOT="${D}" man_prefix=/usr/share ${myflags} || die
	dodoc CHANGELOG README License pgp.keys.asc doc/capability.notes
}
