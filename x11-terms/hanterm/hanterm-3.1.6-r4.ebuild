# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/hanterm/hanterm-3.1.6-r4.ebuild,v 1.1 2008/12/22 16:44:16 matsuu Exp $

IUSE="utempter"

inherit eutils toolchain-funcs

DESCRIPTION="Hanterm -- Korean terminal"
HOMEPAGE="http://www.hanterm.org/"
SRC_URI="http://download.kldp.net/hanterm/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="X11"

DEPEND="x11-libs/libXmu
	x11-libs/libICE
	x11-libs/libXaw
	utempter? ( sys-libs/libutempter )
	>=x11-libs/Xaw3d-1.5"
RDEPEND="${DEPEND}
	media-fonts/baekmuk-fonts"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gentoo.patch"
}

src_compile() {
	econf \
		--with-Xaw3d \
		$(use_with utempter) \
		|| die "econf failed"
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin hanterm || die

	insinto /usr/share/X11/app-defaults
	newins Hanterm.ad Hanterm.orig
	newins "${FILESDIR}/Hanterm.gentoo" Hanterm

	newman hanterm.man hanterm.1

	dohtml doc/devel/hanterm.html doc/devel/3final.gif

	dodoc README ChangeLog doc/{AUTHORS,THANKS,TODO}
	dodoc doc/devel/hanterm.sgml
	dodoc doc/historic/{ChangeLog*,DGUX.note,README*}
}
