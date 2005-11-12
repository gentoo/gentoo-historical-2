# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/smoke/smoke-3.5.0_rc1.ebuild,v 1.1 2005/11/12 15:49:36 danarmak Exp $

KMNAME=kdebindings
KMEXTRACTONLY="kalyptus/kalyptus kalyptus/*.pm"
KM_MAKEFILESREV=1
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="Scripting Meta Object Kompiler Engine: a language-agnostic bindings generator for qt and kde"
HOMEPAGE="http://developer.kde.org/language-bindings/smoke/"

KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="dev-lang/perl
	dev-python/qscintilla" # QScintilla is an optional dep, there's a configure flag for it, but I don't want
				# to introduce a local noqscintilla use flag as it's a light dep.
				# Of course it'd be nice if someone told me what the difference is between a smoke
				# compiled with and without qscintilla support. --danarmak
PATCHES="$FILESDIR/no-gtk-glib-check.diff"

# enable-final works, but requires at least 1.5GB of RAM to complete without swapping,
# so it's best to turn it off here. (I don't have that much RAM, so can't estimate
# how much would be enough, but it's at least that much... --danarmak)
src_compile() {
	kde-meta_src_compile myconf
	# override myconf's setting of enable-final
	myconf="$myconf --disable-final"

	# Needs patch to fix paralell building again
	MAKEOPTS="$MAKEOPTS -j1"

	kde-meta_src_compile configure make
}
