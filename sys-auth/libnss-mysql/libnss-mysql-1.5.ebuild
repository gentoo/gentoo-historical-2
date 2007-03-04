# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/libnss-mysql/libnss-mysql-1.5.ebuild,v 1.5 2007/03/04 17:09:24 vivo Exp $

inherit multilib

KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DESCRIPTION="NSS MySQL Library."
HOMEPAGE="http://libnss-mysql.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="virtual/mysql"
RDEPEND="${DEPEND}"

src_install() {
	dodir "/etc"
	einstall libdir="${D}/$(get_libdir)"
	rm -f "${D}/$(get_libdir)/libnss_mysql.la"

	newdoc sample/README README.sample
	dodoc AUTHORS DEBUGGING FAQ INSTALL NEWS README THANKS \
		TODO UPGRADING ChangeLog

	for subdir in sample/{linux,freebsd,complex,minimal} ; do
		docinto "${subdir}"
		dodoc "${subdir}/"{*.sql,*.cfg}
	done
}

pkg_postinst() {
	einfo "As of version 1.3, the [section] lines in the configuration files"
	einfo "are meaningless and will be ignored. Remove them to avoid extra"
	einfo "parsing overhead."
}
