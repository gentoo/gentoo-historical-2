# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gedit/gedit-2.30.3.ebuild,v 1.4 2010/08/01 09:14:11 pacho Exp $

GCONF_DEBUG="no"

inherit gnome2 python eutils

DESCRIPTION="A text editor for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="doc python spell"

RDEPEND=">=gnome-base/gconf-2
	>=x11-libs/libSM-1.0
	>=dev-libs/libxml2-2.5.0
	>=dev-libs/glib-2.23.1
	>=x11-libs/gtk+-2.16.0
	>=x11-libs/gtksourceview-2.9.7
	spell? (
		>=app-text/enchant-1.2
		>=app-text/iso-codes-0.35
	)
	python? (
		>=dev-python/pygobject-2.15.4
		>=dev-python/pygtk-2.12
		>=dev-python/pygtksourceview-2.9.2
	)"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9
	>=app-text/scrollkeeper-0.3.11
	>=app-text/gnome-doc-utils-0.3.2
	~app-text/docbook-xml-dtd-4.1.2
	doc? ( >=dev-util/gtk-doc-1 )"
# gnome-common and gtk-doc-am needed to eautoreconf

DOCS="AUTHORS BUGS ChangeLog MAINTAINERS NEWS README"

if [[ "${ARCH}" == "PPC" ]] ; then
	# HACK HACK HACK: someone fix this garbage
	MAKEOPTS="${MAKEOPTS} -j1"
fi

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-updater
		$(use_enable python)
		$(use_enable spell)"
}

src_unpack() {
	gnome2_src_unpack

	# Do not fail if remote mounting is not supported.
	epatch "${FILESDIR}/${PN}-2.30.2-tests-skip.patch"

	# disable pyc compiling
	mv "${S}"/py-compile "${S}"/py-compile.orig
	ln -s $(type -P true) "${S}"/py-compile
}

src_install() {
	gnome2_src_install

	# Installed for plugins, but they're dlopen()-ed
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	use python && python_mod_optimize /usr/$(get_libdir)/gedit-2/plugins
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/gedit-2/plugins
}
