# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/scgi/scgi-1.10.ebuild,v 1.3 2008/01/10 10:42:48 gmsoft Exp $

inherit distutils

DESCRIPTION="Replacement for the CGI protocol that is similar to FastCGI"
HOMEPAGE="http://www.mems-exchange.org/software/scgi/"
SRC_URI="http://www.mems-exchange.org/software/files/${PN}/${P}.tar.gz"

LICENSE="CNRI"
SLOT="0"
KEYWORDS="~amd64 hppa ~ppc ~x86"
IUSE=""

pkg_postinst() {
	distutils_pkg_postinst
	einfo "This package does not install mod_scgi"
	einfo "Please 'emerge mod_scgi' if you need it"
}
