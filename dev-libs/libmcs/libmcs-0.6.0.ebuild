# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmcs/libmcs-0.6.0.ebuild,v 1.10 2008/01/16 19:43:34 armin76 Exp $

inherit flag-o-matic kde-functions multilib

DESCRIPTION="Abstracts the storage of configuration settings away from applications."
HOMEPAGE="http://sacredspiral.co.uk/~nenolod/mcs/"
SRC_URI="http://distfiles.atheme.org/${P}.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha ~amd64 hppa ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="gnome kde"

RDEPEND=">=dev-libs/libmowgli-0.4.0
	gnome? ( >=gnome-base/gconf-2.6.0 )
	kde? ( kde-base/kdelibs )"

src_compile() {
	if use kde; then
	    set-kdedir
	    append-ldflags "-L${KDEDIR}/$(get_libdir)"
	    append-flags "-I${KDEDIR}/include -I${QTDIR}/include"
	fi
	econf \
		$(use_enable gnome gconf) \
		$(use_enable kde kconfig) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS README TODO
}
