# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gksu/gksu-1.0.5.ebuild,v 1.3 2004/04/26 08:23:18 dholm Exp $

DESCRIPTION="This library provides a gtk+ front end to su and sudo"

HOMEPAGE="http://www.nongnu.org/gksu/"

SRC_URI="http://people.debian.org/~kov/gksu/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86 ~ppc"

IUSE="nls"

DEPEND="sys-apps/gawk
	sys-apps/sed
	sys-apps/grep
	>=x11-libs/gtk+-2
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )
	sys-devel/libtool
	sys-devel/gcc
	virtual/glibc
	>=dev-util/gtk-doc-1.0
	sys-devel/m4
	sys-devel/bison"

RDEPEND="dev-libs/atk
	dev-libs/expat
	dev-libs/glib
	media-libs/fontconfig
	media-libs/freetype
	virtual/glibc
	sys-libs/zlib
	virtual/x11
	x11-libs/gtk+
	x11-libs/pango
	app-admin/sudo"


src_compile() {

	econf `use_enable nls` || die "Configure failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die
}
