# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/sed/sed-4.0.8.ebuild,v 1.2 2003/11/17 23:59:46 kumba Exp $

DESCRIPTION="Super-useful stream editor"
SRC_URI="ftp://ftp.gnu.org/pub/gnu/sed/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/sed/sed.html"

KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~alpha ~hppa ~arm ~mips ~ia64"
SLOT="0"
LICENSE="GPL-2"
IUSE="nls static build"

inhereit gnuconfig

DEPEND="virtual/glibc
	nls? ( sys-devel/gettext )"

src_compile() {
	local myconf

	# Allow sed to detect mips systems properly
	use mips && gnuconfig_update

	use nls \
		&& myconf="${myconf} --enable-nls" \
		|| myconf="${myconf} --disable-nls"

	econf ${myconf} || die "Configure failed"
	if [ -z `use static` ] ; then
		emake || die "Shared build failed"
	else
		emake LDFLAGS=-static || die "Static build failed"
	fi
}

src_install() {
	into /
	dobin sed/sed
	if [ -z "`use build`" ]
	then
		einstall || die "Install failed"
		dodoc COPYING NEWS README* THANKS TODO AUTHORS BUGS ANNOUNCE ChangeLog
		docinto examples
		dodoc ${FILESDIR}/dos2unix ${FILESDIR}/unix2dos

	else
		dodir /usr/bin
	fi

	rm -f ${D}/usr/bin/sed
	dosym ../../bin/sed /usr/bin/sed
}
