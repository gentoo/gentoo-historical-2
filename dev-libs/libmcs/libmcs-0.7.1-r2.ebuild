# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmcs/libmcs-0.7.1-r2.ebuild,v 1.4 2008/11/26 16:27:45 ranger Exp $

DESCRIPTION="Abstracts the storage of configuration settings away from applications."
HOMEPAGE="http://sacredspiral.co.uk/~nenolod/mcs/"
SRC_URI="http://distfiles.atheme.org/${P}.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~mips ~ppc ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="gnome"

RDEPEND=">=dev-libs/libmowgli-0.6.1
	gnome? ( >=gnome-base/gconf-2.6.0 )"
DEPEND=">=dev-util/pkgconfig-0.9.0
	${RDEPEND}"

src_compile() {
	econf \
		--disable-kconfig \
		$(use_enable gnome gconf) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS README TODO
}
