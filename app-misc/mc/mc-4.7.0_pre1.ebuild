# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mc/mc-4.7.0_pre1.ebuild,v 1.2 2009/08/02 14:43:46 ssuominen Exp $

EAPI=2

MY_P=${P/_/-}

DESCRIPTION="GNU Midnight Commander is a text based file manager"
HOMEPAGE="http://www.midnight-commander.org"
SRC_URI="http://www.midnight-commander.org/downloads/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="gpm nls +slang X"

RDEPEND=">=dev-libs/glib-2.6:2
	gpm? ( sys-libs/gpm )
	samba? ( net-fs/samba )
	slang? ( >=sys-libs/slang-2 )
	!slang? ( sys-libs/ncurses )
	X? ( x11-libs/libX11
		x11-libs/libICE
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libSM )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${MY_P}

src_configure() {
	local myscreen=ncurses

	use slang && myscreen=slang

	econf \
		--disable-dependency-tracking \
		--enable-vfs \
		--enable-charset \
		$(use_with X x) \
		$(use_with samba) \
		--with-configdir=/etc/samba \
		--with-codepagedir=/var/lib/samba/codepages \
		$(use_with gpm gpm-mouse) \
		--with-screen=${myscreen} \
		--with-edit
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README

	insinto /usr/share/mc/syntax
	doins "${FILESDIR}"/ebuild.syntax || die "doins failed"
}
