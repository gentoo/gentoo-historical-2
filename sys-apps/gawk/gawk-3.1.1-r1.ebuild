# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gawk/gawk-3.1.1-r1.ebuild,v 1.1 2002/11/14 19:32:45 azarah Exp $

IUSE="nls build"

S="${WORKDIR}/${P}"
DESCRIPTION="GNU awk pattern-matching language"
SRC_URI="ftp://gatekeeper.dec.com/pub/GNU/gawk/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/gawk/gawk.html"

KEYWORDS="x86 ppc sparc sparc64 alpha"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc
	nls? ( sys-devel/gettext )"

src_compile() {
	local myconf=""
	use nls || myconf="${myconf} --disable-nls"

	./configure --prefix=/usr \
		--libexecdir=/usr/lib/awk \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--host=${CHOST} \
		${myconf} || die

	emake || die
}

src_install() {
	make prefix=${D}/usr \
		bindir=${D}/bin \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		libexecdir=${D}/usr/lib/awk \
		install || die
		
	rm -f ${D}/bin/{awk,gawk}
	dosym gawk-${PV} /bin/awk
	dosym gawk-${PV} /bin/gawk
	#compat symlink
	dodir /usr/bin
	dosym ../../bin/gawk-${PV} /usr/bin/awk
	dosym ../../bin/gawk-${PV} /usr/bin/gawk

	# Install headers
	insinto /usr/include/awk
	doins ${S}/*.h
	
	if [ -z "`use build`" ] 
	then
		dosym gawk.1.gz /usr/share/man/man1/awk.1.gz
		dodoc ChangeLog ACKNOWLEDGMENT COPYING FUTURES
		dodoc LIMITATIONS NEWS PROBLEMS README
		docinto README_d
		dodoc README_d/*
		docinto atari
		dodoc atari/ChangeLog atari/README.1st
		docinto awklib
		dodoc awklib/ChangeLog
		docinto pc
		dodoc pc/ChangeLog
		docinto posix
		dodoc posix/ChangeLog
	else
		rm -rf ${D}/usr/share
	fi
}

