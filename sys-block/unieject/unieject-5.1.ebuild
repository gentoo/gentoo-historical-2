# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/unieject/unieject-5.1.ebuild,v 1.1 2005/12/30 20:03:17 flameeyes Exp $

DESCRIPTION="Multiplatform command to eject and load CD-Rom drives"
HOMEPAGE="http://dev.gentoo.org/~flameeyes/projects"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="nls"

RDEPEND=">=dev-libs/libcdio-0.75-r1
	dev-libs/popt
	>=dev-libs/confuse-2.5
	nls? ( sys-devel/gettext )
	!virtual/eject"
DEPEND="${RDEPEND}
	sys-apps/sed"

PROVIDE="virtual/eject"

src_compile() {
	econf \
		$(use_enable nls) \
		--enable-lock-workaround \
		--disable-dependency-tracking \
		--disable-doc \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install
	dodoc README ChangeLog NEWS AUTHORS unieject.conf.sample

	# Symlink to eject to provide a good virtual/eject
	dosym unieject.1.gz /usr/share/man/man1/eject.1.gz
	dosym unieject /usr/bin/eject
}
