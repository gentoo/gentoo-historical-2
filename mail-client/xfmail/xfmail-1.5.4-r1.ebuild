# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/xfmail/xfmail-1.5.4-r1.ebuild,v 1.1 2004/05/30 03:07:10 seemant Exp $

IUSE="ldap"
S=${WORKDIR}/${P}
DESCRIPTION="A full-featured mail program using XForms"
SRC_URI="http://xfmail.precision-eng.net/release/${PV}/source/${P}-1.tar.bz2
	http://xfmail.cfreeze.com/release/${PV}/source/${P}-1.tar.bz2
	ftp://ftp.xfmail.org/pub/xfmail/release/${PV}/source/${P}-1.tar.bz2"
HOMEPAGE="http://www.xfmail.org"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc sparc"
DEPEND="virtual/x11
	>=x11-libs/xforms-1.0_rc4
	ldap? ( >=net-nds/openldap-2.0.11 )"
RDEPEND="virtual/x11
	>=x11-libs/xforms-1.0_rc4
	ldap? ( >=net-nds/openldap-2.0.11 )"

src_compile() {
	local myconf
	use ldap && myconf="$myconf --with-ldap"
	./autogen.sh \
		--host=${CHOST}  \
		--prefix=/usr \
		--with-faces $myconf || die
	emake || die
}

src_install () {
	make prefix=${D}/usr \
		manualdir=${D}/usr/share/doc/${PF}/html \
		install || die
	dodoc AUTHORS ChangeLog* NEWS README* TODO*
}
