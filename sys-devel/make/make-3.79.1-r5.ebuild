# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/make/make-3.79.1-r5.ebuild,v 1.11 2004/07/02 08:41:16 eradicator Exp $

inherit gnuconfig

IUSE="nls static build"

S=${WORKDIR}/${P}
DESCRIPTION="Standard tool to compile source trees"
SRC_URI="ftp://prep.ai.mit.edu/gnu/make/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/make/make.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha mips"

DEPEND="virtual/libc nls? ( sys-devel/gettext )"
RDEPEND="virtual/libc"

src_compile() {

	# Detect mips systems properly
	use mips && gnuconfig_update

	local myconf=""
	use nls || myconf="--disable-nls"

	./configure --prefix=/usr \
		--mandir=/usr/share/man \
		--info=/usr/share/info \
		--host=${CHOST} \
		${myconf} || die

	if ! use static
	then
		make ${MAKEOPTS} || die
	else
		make ${MAKEOPTS} LDFLAGS=-static || die
	fi
}

src_install() {
	if ! use build
	then
		make DESTDIR=${D} install || die

		fperms 0755 /usr/bin/make
		dosym make /usr/bin/gmake

		dodoc AUTHORS COPYING ChangeLog NEWS README*
	else
		dobin make
	fi
}
