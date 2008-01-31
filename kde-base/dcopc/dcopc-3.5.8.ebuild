# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/dcopc/dcopc-3.5.8.ebuild,v 1.5 2008/01/31 15:30:38 ranger Exp $

KMNAME=kdebindings
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="C bindings for DCOP"
KEYWORDS="amd64 ~ppc ~ppc64 x86" # broken according to upstream - 3.4a1 README=
DEPEND="=dev-libs/glib-1.2*
	=x11-libs/gtk+-1.2*"

# Make sure to compile this
PATCHES="${FILESDIR}/remove-configure.diff"
