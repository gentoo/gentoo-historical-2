# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libcap/libcap-1.10.ebuild,v 1.9 2003/10/01 11:05:34 vapier Exp $

inherit base flag-o-matic

DESCRIPTION="POSIX 1003.1e capabilities"
HOMEPAGE="http://linux.kernel.org/pub/linux/libs/security/linux-privs/"
SRC_URI="http://www.kernel.org/pub/linux/libs/security/linux-privs/kernel-2.4/${P}.tar.bz2"
LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha mips hppa arm amd64 ia64"
IUSE="python"

#patch is in recent 2.2 kernels so it works there
DEPEND="virtual/glibc
	virtual/os-headers
	python? ( >=virtual/python-2.2.1 >=dev-lang/swig-1.3.10 )"
RDEPEND="python? ( >=virtual/python-2.2.1 )"

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PF}-python.patch
}

src_compile() {
	PYTHONVER="`python -V 2>&1 | sed 's/^Python //'|sed 's/\([0-9]*\.[0-9]*\).*/\1/'`"
	filter-flags -fPIC
	local myflags
	myflags=""
	if [ "`use python`" ]; then
		myflags="${myflags} PYTHON=1 PYTHONMODDIR=/usr/lib/python${PYTHONVER}/site-packages"
		CFLAGS="${CFLAGS} -I/usr/include/python${PYTHONVER}"
	fi

	has_version 'sys-devel/hardened-gcc' && \
	append-flags "-yet_exec -fstack-protector -Wl,$(gcc-config -L)/libgcc.a -Wl,/lib/libc.so.6"

	emake COPTFLAG="${CFLAGS}" DEBUG="" ${myflags} || die
}

src_install() {
	PYTHONVER="`python -V 2>&1 | sed 's/^Python //'|sed 's/\([0-9]*\.[0-9]*\).*/\1/'`"
	local myflags
	myflags=""
	if [ "`use python`" ]; then
		myflags="${myflags} PYTHON=1 PYTHONMODDIR=${D}/usr/lib/python${PYTHONVER}/site-packages"
	fi
	make install FAKEROOT="${D}" man_prefix=/usr/share ${myflags} || die
	dodoc CHANGELOG README License pgp.keys.asc doc/capability.notes
}
