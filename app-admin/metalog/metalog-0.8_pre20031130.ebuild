# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/metalog/metalog-0.8_pre20031130.ebuild,v 1.12 2004/06/24 21:31:41 agriffis Exp $

DESCRIPTION="A highly configurable replacement for syslogd/klogd"
HOMEPAGE="http://metalog.sourceforge.net/"
SRC_URI="mirror://sourceforge/metalog/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc mips alpha hppa ~amd64 ia64 ppc64"
IUSE=""

DEPEND=">=dev-libs/libpcre-3.4
	sys-devel/automake"
RDEPEND=">=dev-libs/libpcre-3.4"
PROVIDE="virtual/logger"

src_unpack() {
	unpack ${A} ; cd ${S}
	cd ${S}/src
	sed -i -e "s:/metalog.conf:/metalog/metalog.conf:g" \
		metalog.h
	cd ${S}/man
	sed -i -e "s:/etc/metalog.conf:/etc/metalog/metalog.conf:g" \
		metalog.8
}

src_compile() {
	aclocal
	autoheader
	automake --add-missing --gnu
	autoconf

	econf || die "econf failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog README NEWS
	newdoc metalog.conf metalog.conf.sample

	insinto /etc/metalog ; doins ${FILESDIR}/metalog.conf
	exeinto /etc/init.d ; newexe ${FILESDIR}/metalog.rc6 metalog
	insinto /etc/conf.d ; newins ${FILESDIR}/metalog.confd metalog

	exeinto /usr/sbin
	doexe ${FILESDIR}/consolelog.sh
}

pkg_postinst() {
	einfo "Buffering is now off by default.  Add -a to METALOG_OPTS"
	einfo "in /etc/conf.d/metalog to turn buffering back on."
}
