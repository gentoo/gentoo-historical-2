# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/psmisc/psmisc-22.5-r2.ebuild,v 1.10 2007/09/27 15:28:18 josejx Exp $

inherit eutils autotools

DESCRIPTION="A set of tools that use the proc filesystem"
HOMEPAGE="http://psmisc.sourceforge.net/"
SRC_URI="mirror://sourceforge/psmisc/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
IUSE="ipv6 nls selinux X"

RDEPEND=">=sys-libs/ncurses-5.2-r2
	selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}
	sys-devel/libtool
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-22.2-gcc2.patch
	epatch "${FILESDIR}"/${P}-user-header.patch
	epatch "${FILESDIR}"/${P}-sockets.patch
	# this package doesnt actually need C++
	sed -i '/AC_PROG_CXX/d' configure.ac || die
	eautoreconf
}

src_compile() {
	econf \
		$(use_enable selinux) \
		$(use_enable nls) \
		$(use_enable ipv6) \
		|| die
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README
	use X || rm "${D}"/usr/bin/pstree.x11
	# fuser is needed by init.d scripts
	dodir /bin
	mv "${D}"/usr/bin/fuser "${D}"/bin/ || die
	# easier to do this than forcing regen of autotools
	[[ -e ${D}/usr/bin/peekfd ]] || rm -f "${D}"/usr/share/man/man1/peekfd.1
}
