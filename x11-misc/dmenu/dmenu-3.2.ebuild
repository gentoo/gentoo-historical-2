# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/dmenu/dmenu-3.2.ebuild,v 1.6 2008/07/20 14:38:42 cedk Exp $

inherit toolchain-funcs savedconfig

DESCRIPTION="a generic, highly customizable, and efficient menu for the X Window System"
HOMEPAGE="http://www.suckless.org/programs/dmenu.html"
SRC_URI="http://code.suckless.org/dl/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

DEPEND="x11-libs/libX11"
RDEPEND=${DEPEND}

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "s/CFLAGS = -Os/CFLAGS += -g/" \
		-e "s/LDFLAGS = -s/LDFLAGS += -g/" \
		config.mk || die "sed failed"

	if use savedconfig; then
		restore_config ${PN}.h
	fi
}

src_compile() {
	local msg
	use savedconfig && msg=", please check the configfile"
	emake CC=$(tc-getCC) || die "emake failed${msg}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install || die "emake install failed"

	insinto /usr/share/${PN}
	newins ${PN}.h ${PF}.config.h

	dodoc README

	save_config ${PN}.h
}

pkg_postinst() {
	einfo "This ebuild has support for user defined configs"
	einfo "Please read this ebuild for more details and re-emerge as needed"
	einfo "if you want to add or remove functionality for ${PN}"
}
