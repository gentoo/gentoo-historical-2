# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/conky/conky-1.3.4.ebuild,v 1.1 2005/11/20 00:09:28 dragonheart Exp $

inherit eutils

DESCRIPTION="Conky is an advanced, highly configurable system monitor for X"
HOMEPAGE="http://conky.sf.net"
SRC_URI="mirror://sourceforge/conky/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="truetype seti X ipv6"

DEPEND_COMMON="
	virtual/libc
	X? (
		virtual/x11
		truetype? ( >=media-libs/freetype-2 )
	)"

RDEPEND="${DEPEND_COMMON}
	seti? ( sci-astronomy/setiathome )"

DEPEND="
	${DEPEND_COMMON}
	>=sys-devel/automake-1.9
	>=sys-devel/autoconf-2.59
	sys-devel/libtool
	sys-apps/grep
	sys-apps/sed
	sys-devel/gcc"


src_compile() {
	local mymake
	if useq ipv6 ; then
		ewarn
		ewarn "You have the ipv6 USE flag enabled.  Please note that"
		ewarn "using the ipv6 USE flag with Conky disables the port"
		ewarn "monitor."
		ewarn
		sleep 5
	else
		mymake="MPD_NO_IPV6=noipv6"
	fi
	local myconf
	myconf="--enable-double-buffer --enable-own-window --enable-proc-uptime
	--enable-mpd --enable-mldonkey"
	econf \
		${myconf} \
		$(use_enable truetype xft) \
		$(use_enable X x11) \
		$(use_enable !ipv6 portmon) \
		$(use_enable seti) || die "econf failed"
	emake ${mymake} || die "compile failed"
}

src_install() {
	emake DESTDIR=${D} install || die "make install failed"
	dodoc ChangeLog AUTHORS README doc/conkyrc.sample doc/variables.html
	dodoc doc/docs.html doc/config_settings.html
}

pkg_postinst() {
	einfo 'Default configuration file is "~/.conkyrc"'
	einfo "you can find a sample configuration file in"
	einfo "/usr/share/doc/${PF}/conkyrc.sample.gz"
	einfo
	einfo "For more info on Conky's new features,"
	einfo "please look at the README and ChangeLog:"
	einfo "/usr/share/doc/${PF}/README.gz"
	einfo "/usr/share/doc/${PF}/ChangeLog.gz"
	einfo "There are also pretty html docs available"
	einfo "on Conky's site or in /usr/share/doc/${PF}"
	einfo
	einfo "Comment out temperature info lines if you have no kernel"
	einfo "support for it."
	einfo
	einfo "Check out app-vim/conky-syntax for conkyrc"
	einfo "syntax highlighting in Vim"
	einfo
	ewarn "Conky doesn't work with window managers that"
	ewarn "take control over root window such as Gnome's nautilus."
	ewarn
}
