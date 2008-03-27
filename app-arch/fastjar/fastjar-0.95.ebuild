# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/fastjar/fastjar-0.95.ebuild,v 1.4 2008/03/27 15:34:13 corsair Exp $

DESCRIPTION="A jar program written in C"
HOMEPAGE="https://savannah.nongnu.org/projects/fastjar"
SRC_URI="http://download.savannah.nongnu.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ppc64 ~x86"

IUSE=""

# bug #188542
RDEPEND="!<=dev-java/kaffe-1.1.7-r5"
DEPEND=""

src_install() {
	emake DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO || die
}
