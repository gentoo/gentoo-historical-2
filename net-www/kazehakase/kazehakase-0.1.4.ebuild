# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/kazehakase/kazehakase-0.1.4.ebuild,v 1.4 2004/04/27 20:08:01 agriffis Exp $

inherit eutils

IUSE=""

DESCRIPTION="Kazehakase is a browser with gecko engine like Epiphany or Galeon."
HOMEPAGE="http://kazehakase.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/8924/${P}.tar.gz"

SLOT="0"
KEYWORDS="~x86 ~alpha ~amd64 ~ppc"
LICENSE="GPL-2"

DEPEND="${DEPEND}
	sys-devel/automake
	sys-devel/libtool
	<net-www/mozilla-1.7
	x11-libs/pango
	>=x11-libs/gtk+-2*
	dev-util/pkgconfig"

S="${WORKDIR}/${P}"

pkg_setup(){
	if grep -v gtk2 /var/db/pkg/net-www/mozilla-[[:digit:]]*/USE > /dev/null
	then
		echo
		eerror
		eerror "This needs mozilla used gtk2."
		eerror "To build mozilla use gtk2, please type following command:"
		eerror
		eerror "    # USE=\"gtk2\" emerge mozilla"
		eerror
		die
	fi
}

src_compile(){
	export WANT_AUTOCONF=2.5
	export WANT_AUTOMAKE=1.6

	epatch ${FILESDIR}/kz-scrap-bookmark-action.gcc2.patch
	epatch ${FILESDIR}/kz-tab-label.gcc2.patch

	./autogen.sh || die
	econf || die
	emake || die
}

src_install(){
	emake DESTDIR="${D}" install || die
	dodoc ABOUT-NLS AUTHORS COPYING* ChangeLog NEWS README* TODO.ja
}
