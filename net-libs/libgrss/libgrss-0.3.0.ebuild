# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libgrss/libgrss-0.3.0.ebuild,v 1.1 2010/04/10 11:11:39 lxnay Exp $

EAPI=3

inherit gnome2

DESCRIPTION="LibGRSS is a library for easy management of RSS/Atom/Pie feeds"
HOMEPAGE="http://live.gnome.org/Libgrss"
SRC_URI="http://gtk.mplat.es/libgrss/tarballs/${P}.tar.gz"
# TODO: once upstream will move to GNOME FTP
#	mirror://gnome/sources/libgrss/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND=">=dev-libs/glib-2.22.2:2
	>=dev-libs/libxml2-2.7.4:2
	>=net-libs/libsoup-2.28.1:2.4"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext
	dev-util/intltool
	doc? ( dev-util/gtk-doc )
	gnome-base/gnome-common
	sys-devel/autoconf:2.5
	sys-devel/automake:1.10
	sys-devel/libtool"

src_install() {
	DOCS="AUTHORS ChangeLog NEWS README"
	gnome2_src_install

	rm "${D}"/usr/lib*/*.la || die "removing .la files failed"

	rm -rf "${D}/var" || die "removing empty dir failed"

	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
