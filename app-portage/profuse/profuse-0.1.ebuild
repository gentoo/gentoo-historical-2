# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/profuse/profuse-0.1.ebuild,v 1.4 2005/07/09 02:21:07 agriffis Exp $

MY_P=${PN}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="use flags and profile gtk2 editor. It should be a good ufed alternative"
HOMEPAGE="http://libconf.net/profuse/"
SRC_URI="http://libconf.net/profuse/download/profuse-0.1.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64"
IUSE=""

DEPEND="dev-perl/gtk2-fu
>=dev-util/libconf-0.39.3"

src_compile() {
	emake || die "make failed"
}

src_install() {
	einstall PREFIX=${D}/usr
}
