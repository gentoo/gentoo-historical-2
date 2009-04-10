# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/devhelp/devhelp-0.21-r1.ebuild,v 1.3 2009/04/10 20:46:55 bluebird Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit autotools eutils toolchain-funcs gnome2 python

DESCRIPTION="An API documentation browser for GNOME 2"
HOMEPAGE="http://developer.imendio.com/wiki/Devhelp"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="zlib"

RDEPEND=">=gnome-base/gconf-2.6
	>=x11-libs/gtk+-2.8
	>=dev-libs/glib-2.8
	>=gnome-base/libglade-2.4
	>=x11-libs/libwnck-2.10
	=net-libs/xulrunner-1.9*
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	  sys-devel/gettext
	>=dev-util/intltool-0.35.5
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile

	# Allow to build against libxul, bug #250306
	epatch "${FILESDIR}/${P}-xulrunner19.patch"

	eautoreconf
}

pkg_setup() {
	if has_version app-editors/gedit && \
		! built_with_use app-editors/gedit python; then
		# Add warning per bug #245235
		ewarn "dev-util/devhelp plugin for app-editors/gedit needs python support"
	fi

	G2CONF="$(use_with zlib)
		--with-gecko=libxul
		--with-gecko-home=/usr/$(get_libdir)/xulrunner-1.9"

	# ICC is crazy, silence warnings (bug #154010)
	if [[ $(tc-getCC) == "icc" ]] ; then
		G2CONF="${G2CONF} --with-compile-warnings=no"
	fi
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/gedit-2/plugins/devhelp
}

pkg_postrm() {
	python_mod_cleanup
}
