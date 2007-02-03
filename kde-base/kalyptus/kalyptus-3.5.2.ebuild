# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kalyptus/kalyptus-3.5.2.ebuild,v 1.10 2007/02/03 09:25:11 mr_bones_ Exp $

KMNAME=kdebindings
KM_MAKEFILESREV=1
MAXKDEVER=3.5.4
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE bindings generator for C, ObjC and Java"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"
IUSE=""
DEPEND="dev-lang/perl"
PATCHES="$FILESDIR/no-gtk-glib-check.diff"

# Weird build system, weirder errors.
# You're welcome to fix this in a better way --danarmak
src_compile () {
	export S=$S/kalyptus
	kde-meta_src_compile
}

src_install() {
	cd $S/kalyptus
	make install DESTDIR=$D
}
