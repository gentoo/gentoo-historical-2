# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxde-base/lxsession-edit/lxsession-edit-0.1.1.ebuild,v 1.5 2009/08/05 19:47:15 volkmar Exp $

EAPI="1"

inherit autotools eutils

DESCRIPTION="LXDE session autostart editor"
HOMEPAGE="http://lxde.sourceforge.net/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

CDEPEND="dev-libs/glib:2
	x11-libs/gtk+:2"
RDEPEND="${CDEPEND}
	lxde-base/lxde-common
	lxde-base/lxsession"
DEPEND="${CDEPEND}
	sys-devel/gettext
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-intltool.patch

	# Rerun autotools
	einfo "Regenerating autotools files..."
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README || die 'dodoc failed'
}
