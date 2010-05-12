# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/email2trac/email2trac-1.3.2.ebuild,v 1.1 2010/05/12 08:12:42 hollow Exp $

EAPI="2"

inherit python

DESCRIPTION="Utilites to convert emails into trac objects"
HOMEPAGE="https://subtrac.sara.nl/oss/email2trac/"
SRC_URI="ftp://ftp.sara.nl/pub/outgoing/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=""
RDEPEND=""

pkg_setup() {
	einfo "You can set the following variables in make.conf:"
	einfo " - EMAIL2TRAC_TRAC_USER (default: apache)"
	einfo " - EMAIL2TRAC_MTA_USER (default: nobody)"
}

src_configure() {
	econf --sysconfdir=/etc/${PN}/ \
		--with-trac_user=${EMAIL2TRAC_TRAC_USER:-apache} \
		--with-MTA_user=${EMAIL2TRAC_MTA_USER:-nobody}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
