# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/edox-data/edox-data-0.16.7_pre1.ebuild,v 1.2 2004/06/24 21:45:52 agriffis Exp $

inherit eutils

EVER="${PV/_pre*}"
EDOXVER="${EVER}-0.02"
DESCRIPTION="The Enlightenment online help"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="mirror://sourceforge/enlightenment/edox-data-${EDOXVER}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64 ~ia64"
IUSE=""

DEPEND=">=x11-wm/enlightenment-0.16.7_pre1"

S=${WORKDIR}/edox-data-${EVER}

src_compile() {
	econf --enable-fsstd || die
	emake || die
}

src_install() {
	make install DESTDIR=${D} || die
	dodoc AUTHORS ChangeLog NEWS README
}
