# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/sim/sim-0.9.2.ebuild,v 1.12 2005/01/15 00:07:07 danarmak Exp $

if use kde; then
	inherit kde-base eutils
	need-kde 3
else
	inherit base kde-functions eutils
	need-qt 3
fi

LICENSE="GPL-2"
DESCRIPTION="An ICQ v8 Client. Supports File Transfer, Chat, Server-Side Contactlist, ..."
SRC_URI="mirror://sourceforge/sim-icq/${P}.tar.gz
	mirror://gentoo/sim-cvs-admin.tar.bz2 http://gentoo.tamperd.net/distfiles/sim-cvs-admin.tar.bz2"
RESTRICT="nomirror"
HOMEPAGE="http://sim-icq.sourceforge.net"
KEYWORDS="x86 ~ppc -amd64"
SLOT="0"
IUSE="ssl kde"

RDEPEND="ssl? ( dev-libs/openssl )
	app-text/sablotron"
DEPEND="$RDEPEND
	sys-devel/flex
	sys-devel/automake
	>=sys-devel/autoconf-2.58
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${P}.tar.gz ; cd ${S}
	rm -rf admin/
	unpack sim-cvs-admin.tar.bz2

	sed -i 's:rm -rf $(sim_plugindir)/.*::g' plugins/*/Makefile.am
}

src_compile() {
	local myconf

	myconf="$( use_enable ssl openssl )"
	myconf="$myconf $( use_enable kde )"
	myconf="$myconf --without-gkrellm_plugin"
	myconf="$myconf --prefix=/usr"

	if use kde; then
		need-kde 3
	else
		need-qt 3
	fi

	export WANT_AUTOCONF=2.5
	export WANT_AUTOMAKE=1.7

	make -f admin/Makefile.common

	use kde && kde_src_compile myconf

	econf $myconf --without-gkrellm || die
	make clean  || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc TODO README ChangeLog COPYING AUTHORS
}
