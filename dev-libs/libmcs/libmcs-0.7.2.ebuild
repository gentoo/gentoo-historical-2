# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmcs/libmcs-0.7.2.ebuild,v 1.5 2012/02/17 20:29:56 jdhore Exp $

EAPI=4

DESCRIPTION="Abstracts the storage of configuration settings away from applications."
HOMEPAGE="http://git.atheme.org/libmcs/"
SRC_URI="http://distfiles.atheme.org/${P}.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE="gnome"

RDEPEND=">=dev-libs/libmowgli-0.6.1:0
	gnome? ( >=gnome-base/gconf-2.6.0 )"
DEPEND=">=dev-util/pkgconfig-0.9.0
	${RDEPEND}"
DOCS="AUTHORS README TODO"

src_configure() {
	econf \
		--disable-kconfig \
		$(use_enable gnome gconf)
}
