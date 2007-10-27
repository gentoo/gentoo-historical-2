# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/justeport/justeport-0.2.ebuild,v 1.1 2007/10/27 11:42:31 drac Exp $

inherit mono multilib

MY_P=JustePort-${PV}

DESCRIPTION="Stream audio to your AirPort Express"
HOMEPAGE="http://nanocrew.net/software/justeport/"
SRC_URI="http://nanocrew.net/sw/justeport/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/mono"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp "${FILESDIR}"/wrapper-script .
	sed -i -e "s:LIBDIR:$(get_libdir):" wrapper-script
}

src_compile() {
	emake || die "emake failed."
}

src_install() {
	insinto /usr/$(get_libdir)/justeport
	doins *.exe
	newbin wrapper-script justeport
	dodoc AUTHORS ChangeLog README THANKS
}
