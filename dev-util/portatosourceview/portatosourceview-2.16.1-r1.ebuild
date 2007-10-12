# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/portatosourceview/portatosourceview-2.16.1-r1.ebuild,v 1.3 2007/10/12 09:09:42 remi Exp $

WANT_AUTOCONF=latest
WANT_AUTOMAKE=1.9
inherit distutils gnome2 python virtualx autotools

DESCRIPTION="A gtksourceview widget for portato (based on pygtk)."
HOMEPAGE="http://portato.sourceforge.net/"
SRC_URI="mirror://sourceforge/portato/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"

RDEPEND="virtual/python
	=x11-libs/gtksourceview-1.8*"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.7"

DOCS="AUTHORS ChangeLog NEWS README"

src_install()
{
	gnome2_src_install

	# install plugins
	insinto "/usr/share/portato/plugins"
	doins *.xml
}

pkg_postinst()
{
	python_version
	python_mod_optimize ${ROOT}/usr/$(get_libdir)/python${PYVER}/site-packages/${PN}
}

pkg_postrm()
{
	python_version
	python_mod_cleanup
}
