# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/thunarx-python/thunarx-python-0.3.0.ebuild,v 1.2 2011/05/19 22:32:24 ssuominen Exp $

EAPI=3
PYTHON_DEPEND=2
inherit python xfconf

DESCRIPTION="Python bindings for the Thunar file manager"
HOMEPAGE="http://goodies.xfce.org/projects/bindings/thunarx-python"
SRC_URI="mirror://xfce/src/bindings/${PN}/0.3/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="x11-libs/gtk+:2
	dev-libs/glib:2
	>=dev-python/pygobject-2.16:2
	dev-python/pygtk:2
	>=xfce-base/thunar-1.1.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	XFCONF=(
		--disable-dependency-tracking
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README )

	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	xfconf_src_install \
		docsdir=/usr/share/doc/${PF} \
		examplesdir=/usr/share/doc/${PF}/examples
}
