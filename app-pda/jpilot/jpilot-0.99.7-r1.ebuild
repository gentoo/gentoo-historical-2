# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/jpilot/jpilot-0.99.7-r1.ebuild,v 1.6 2005/03/20 18:29:36 weeve Exp $

inherit eutils

DESCRIPTION="Desktop Organizer Software for the Palm Pilot"
HOMEPAGE="http://jpilot.org/"
SRC_URI="http://jpilot.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ia64 ~ppc sparc x86"
IUSE="nls gtk2"

RDEPEND="gtk2? ( >=x11-libs/gtk+-2 )
	!gtk2? ( >=x11-libs/gtk+-1.2 )
	>=app-pda/pilot-link-0.11.5"
DEPEND="${RDEPEND}
	gtk2? ( dev-util/pkgconfig )
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd ${S} || die

	# Patch for gcc-2.95 compilation, thanks to Matt Black in #70127
	epatch ${FILESDIR}/jpilot-0.99.7-gcc2.patch

	# There are four icons available.  Use the third.
	sed -i 's/jpilot.xpm/jpilot-icon3.xpm/' jpilot.desktop || die
}

src_compile() {
	econf $(use_enable gtk2) $(use_enable nls) || die "configure failed"
	emake -j1 || die "make failed"
}

src_install() {
	make install DESTDIR=${D} \
		docdir=/usr/share/doc/${PF} \
		icondir=/usr/share/pixmaps \
		desktopdir=/usr/share/applications || die "install failed"

	dodoc README TODO UPGRADING ABOUT-NLS BUGS ChangeLog COPYING INSTALL
	doman docs/*.1

	dodir /usr/share/${PN}
	insinto /usr/share/${PN}
	doins ${S}/jpilotrc.*
}

pkg_postinst() {
	einfo
	einfo "The jpilot-syncmal plugin has moved to its own ebuild."
	einfo "If you want to use that plugin, please run"
	einfo "    emerge jpilot-syncmal"
	einfo
	einfo "There are other plugins available as well.  To see the"
	einfo "list, please run"
	einfo "    emerge -s jpilot"
	einfo
}
