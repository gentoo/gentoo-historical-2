# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/skkserv/skkserv-9.6-r1.ebuild,v 1.4 2003/09/08 00:57:32 lanius Exp $

MY_P="skk${PV}mu"
DESCRIPTION="Dictionary server for the SKK Japanese-input software"
HOMEPAGE="http://openlab.ring.gr.jp/skk/"
SRC_URI="http://openlab.ring.gr.jp/skk/maintrunk/museum/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc ~alpha"

DEPEND="virtual/glibc
	>=app-i18n/skk-jisyo-200210"
PROVIDE="virtual/skkserv"

S="${WORKDIR}/skk-${PV}mu"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--libexecdir=/usr/sbin \
		|| die "./configure failed"
	cd skkserv
	emake || die
}

src_install() {
	cd skkserv
	dosbin skkserv

	# install rc script and its config file
	exeinto /etc/init.d ; newexe ${FILESDIR}/${P}/skkserv.initd skkserv
}
