# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/kiso/kiso-0.8.2c.ebuild,v 1.4 2005/10/24 17:56:09 dertobi123 Exp $

inherit kde

DESCRIPTION="KIso is a fronted for KDE to make it as easy as possible to create manipulate and extract CD Image files."
HOMEPAGE="http://kiso.sourceforge.net/"
SRC_URI="mirror://sourceforge/kiso/${P}.tar.bz2"
S="${WORKDIR}/${P/c/}"

LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"

SLOT="0"
IUSE=""

DEPEND=">=dev-libs/libcdio-0.73"
RDEPEND="${DEPEND}
	app-cdr/cdrtools
	app-admin/sudo"

need-kde 3.2

pkg_postinst() {
	echo ""
	einfo "Applications KIso will use when available:"
	echo ""
	einfo "to burn cd images         - app-cdr/k3b"
	einfo "to create encypted images - app-crypt/mcrypt"
	einfo "to hex edit images        - kdebase/khexedit, kdebase/kdeutils or app-editors/ghex"
	echo ""
}