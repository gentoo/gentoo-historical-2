# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/scim-tables/scim-tables-0.5.3.ebuild,v 1.3 2005/10/02 01:43:24 kloeri Exp $

inherit kde-functions

DESCRIPTION="Smart Common Input Method (SCIM) Generic Table Input Method Server"
HOMEPAGE="http://www.scim-im.org/"
SRC_URI="mirror://sourceforge/scim/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~ppc ~sparc x86"
IUSE="arts"

DEPEND="|| ( >=app-i18n/scim-1.1 >=app-i18n/scim-cvs-1.1 )"

src_compile() {
	econf $(use_with arts) || die "econf failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "install failed"
	dodoc README ChangeLog AUTHORS
}
