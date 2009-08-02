# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtkglarea/gtkglarea-2.0.1.ebuild,v 1.1 2009/08/02 09:19:41 eva Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="GL extensions for gtk+"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="examples"

RDEPEND=">=x11-libs/gtk+-2.0.3
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS README* docs/*.txt"

pkg_setup() {
	G2CONF="${G2CONF} --disable-static"
}

src_prepare() {
	# Do not build examples
	sed "s:\(SUBDIRS.*\)examples:\1:" -i Makefile.am Makefile.in || die "sed failed"
}

src_install() {
	gnome2_src_install

	if use examples; then
		cd "${S}"/examples
		insinto /usr/share/doc/${PF}/examples
		doins *.c *.h *.lwo README || die "doins failed"
	fi
}
