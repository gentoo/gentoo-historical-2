# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gedit/gedit-2.20.0.ebuild,v 1.3 2007/10/11 18:07:39 remi Exp $

inherit gnome2 eutils autotools

DESCRIPTION="A text editor for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc python spell xattr"

RDEPEND=">=gnome-base/gconf-2
	xattr? ( sys-apps/attr )
	>=dev-libs/glib-2.13.5
	>=x11-libs/gtk+-2.11.6
	=x11-libs/gtksourceview-2*
	>=gnome-base/libgnomeui-2.16
	>=gnome-base/libglade-2.5.1
	>=gnome-base/libgnomeprintui-2.12.1
	>=gnome-base/gnome-vfs-2.16
	spell? (
		>=app-text/enchant-1.2
		app-text/iso-codes
	)
	python? (
		>=dev-python/pygobject-2.11.5
		>=dev-python/pygtk-2.9.7
		>=dev-python/pygtksourceview-2
	)"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/intltool-0.35
	>=app-text/gnome-doc-utils-0.3.2"

DOCS="AUTHORS BUGS ChangeLog MAINTAINERS NEWS README THANKS TODO"

if [[ "${ARCH}" == "PPC" ]] ; then
	# HACK HACK HACK: someone fix this garbage
	MAKEOPTS="${MAKEOPTS} -j1"
fi

pkg_setup() {
	G2CONF="$(use_enable python) $(use_enable spell) $(use_enable xattr attr)"
}

src_unpack() {
	gnome2_src_unpack

	# Remove symbols that are not meant to be part of the docs, and
	# break compilation if USE="doc -python" (bug #158638).
	if use !python && use doc; then
		epatch "${FILESDIR}"/${PN}-2.16.2-no_python_module_docs.patch
	fi

	echo "gedit/gtksourceprintjob.c" >> po/POTFILES.in

	# chown on fbsd doesn't have --reference.  Bug #183691
	epatch "${FILESDIR}"/${PN}-2.18.1-fbsd.patch

	# Make libattr optional; bug #191989
	epatch "${FILESDIR}"/${PN}-2.19.91-libattr.patch

	AT_M4DIR="./m4" eautoreconf
}

