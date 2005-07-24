# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/gauche/gauche-0.8.5.ebuild,v 1.1 2005/07/24 14:21:07 hattya Exp $

inherit eutils flag-o-matic

IUSE="ipv6 nls"

MY_P="${P/g/G}"

DESCRIPTION="A Unix system friendly Scheme Interpreter"
HOMEPAGE="http://gauche.sf.net/"
SRC_URI="mirror://sourceforge/gauche/${MY_P}.tgz"

LICENSE="BSD"
KEYWORDS="~ia64 ~ppc ~sparc ~x86"
SLOT="0"
S="${WORKDIR}/${MY_P}"

DEPEND=">=sys-libs/gdbm-1.8.0"

src_unpack() {

	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${PN}-gdbm-gentoo.diff
	epatch ${FILESDIR}/${PN}-aclocal.m4-cc.diff
	autoconf

}

src_compile() {

	local myconf mycflags

	use ipv6 && myconf="--enable-ipv6"

	if use nls; then
		myconf="${myconf} --enable-multibyte=utf-8"
	else
		myconf="${myconf} --enable-multibyte=euc-jp"
	fi

	strip-flags

	econf ${myconf} --enable-threads=pthreads || die
	emake || die

}

src_test() {

	make -s check || die

}

src_install() {

	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING ChangeLog HACKING INSTALL INSTALL.eucjp README

}
