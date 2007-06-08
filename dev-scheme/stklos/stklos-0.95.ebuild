# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/stklos/stklos-0.95.ebuild,v 1.1 2007/06/08 11:48:39 hkbst Exp $

inherit eutils

DESCRIPTION="fast and light Scheme implementation"
HOMEPAGE="http://www.stklos.org"
SRC_URI="http://www.stklos.org/download/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64"
IUSE="threads ldap gtk gnome"
DEPEND="dev-libs/gmp dev-libs/libpcre dev-libs/boehm-gc
		ldap? ( net-nds/openldap )
		gtk? ( x11-libs/gtk+ )"
#		gnome? ( )" # someone using gnome should figure out what package will enable gnome support
#silex and ``The Dominique Boucher LALR Package'' may also be deps, not in tree though
RDEPEND="${DEPEND}"

pkg_setup() {
	if use threads; then
		built_with_use dev-libs/boehm-gc threads || die "boehm-gc must be built with threads use flag"
	fi
}

src_compile() {
#this used to be necessary
#	econf $(use_enable threads threads pthreads) $(use ldap && echo --enable-ldap) $(use !gtk && echo --disable-gtk) $(use !gnome && echo --disable-gnome)

#anyone interested in lurc threads? not in tree though
	econf $(use_enable threads threads pthreads) $(use_enable ldap) $(use_enable gtk) $(use_enable gnome) \
		--without-gmp-light --without-provided-gc --without-provided-regexp

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
