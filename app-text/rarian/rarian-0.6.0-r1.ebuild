# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/rarian/rarian-0.6.0-r1.ebuild,v 1.1 2007/10/23 18:33:28 leio Exp $

inherit eutils gnome2

DESCRIPTION="A documentation metadata library"
HOMEPAGE="www.freedesktop.org"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="dev-libs/libxslt"
DEPEND="${RDEPEND}
	!<app-text/scrollkeeper-9999"

DOCS="ChangeLog NEWS README"

GCONF=""

src_unpack() {
	# You cannot run src_unpack from gnome2; it will break the install by
	# calling gnome2_omf_fix
	unpack ${A}
	cd "${S}"

	# Only GNU getopt supports long options
	# Scrollkeeper didn't support them, so we'll punt them for now
	epatch "${FILESDIR}/${P}-posix-getopt.patch"

	# Fix memory clobbering leading to outright crash on sparc and ia64
	epatch "${FILESDIR}/${P}-reg-return.patch"

	elibtoolize ${ELTCONF}
}
