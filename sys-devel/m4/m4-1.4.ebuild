# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/m4/m4-1.4.ebuild,v 1.13 2004/03/07 09:28:54 kumba Exp $

IUSE="nls"

inherit eutils gnuconfig

S="${WORKDIR}/${PN}-1.4"
DESCRIPTION="GNU macro processor"
SRC_URI="ftp://ftp.seindal.dk/gnu/${PN}-1.4.tar.gz
	mirror://gentoo/m4_1.4-15.diff.gz"
HOMEPAGE="http://www.gnu.org/software/m4/m4.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ppc sparc alpha mips hppa ia64"

DEPEND="virtual/glibc
	!bootstrap? ( >=sys-devel/libtool-1.3.5-r2 )
	nls? ( sys-devel/gettext )"

RDEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${DISTDIR}/${PN}_1.4-15.diff.gz

	use alpha && gnuconfig_update
}

src_compile() {
	local myconf=

	use nls || myconf="--disable-nls"

	./configure --host=${CHOST} \
		--prefix=/usr \
		--enable-changeword \
		${myconf} || die

	emake || die
}

src_install() {
	make prefix=${D}/usr \
		libexecdir=${D}/usr/lib \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die

#	rm -rf ${D}/usr/include

	dodoc BACKLOG ChangeLog COPYING NEWS README* THANKS TODO
}
