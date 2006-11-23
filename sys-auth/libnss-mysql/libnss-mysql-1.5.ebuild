# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/libnss-mysql/libnss-mysql-1.5.ebuild,v 1.3 2006/11/23 17:23:11 vivo Exp $

inherit multilib

DESCRIPTION="NSS MySQL Library."
HOMEPAGE="http://libnss-mysql.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="virtual/libc
	virtual/mysql
	!sys-libs/nss-mysql"

src_install() {
	dodir "/etc"
	einstall libdir="${D}/$(get_libdir)"

	newdoc sample/README README.sample
	dodoc AUTHORS DEBUGGING FAQ INSTALL NEWS README THANKS \
		TODO UPGRADING ChangeLog

	for subdir in sample/{,complex,minimal} ; do
		docinto "${subdir}"
		dodoc "${subdir}/"{*.sql,*.cfg}
	done
}

pkg_postinst() {
	einfo "As of version 1.3, the [section] lines in the configuration files"
	einfo "are meaningless and will be ignored.  Remove them to avoid extra"
	einfo "parsing overhead."
}
