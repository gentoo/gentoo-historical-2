# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/keepassx/keepassx-0.3.0.ebuild,v 1.1 2008/03/04 10:29:23 opfer Exp $

inherit eutils

DESCRIPTION="Qt password manager compatible with its Win32 and Pocket PC versions"
HOMEPAGE="http://keepassx.sourceforge.net/"
SRC_URI="mirror://sourceforge/keepassx/KeePassX-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"
DEPEND=">=x11-libs/qt-4.1"
RDEPEND="${DEPEND}"
S="${WORKDIR}/KeePassX-${PV}"

pkg_setup() {
	if ! built_with_use --missing true x11-libs/qt qt3support png; then
		eerror
		eerror "You need to rebuild x11-libs/qt with USE=qt3support enabled"
		eerror
		die "please rebuild x11-libs/qt with USE=qt3support"
	fi
}

src_compile() {
	use debug || myconf="DEBUG=1"
	/usr/bin/qmake PREFIX="${D}/usr" ${myconf} || die "qmake failed" 
	emake || die "emake failed"
}

src_install(){
	emake DESTDIR="${D}" install || die
}
