# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/dcopc/dcopc-3.3.1.ebuild,v 1.2 2004/11/07 03:00:32 mr_bones_ Exp $

KMNAME=kdebindings
inherit kde-meta

DESCRIPTION="C bindings for DCOP"
KEYWORDS="~x86"
DEPEND="=dev-libs/glib-1.2*
	=x11-libs/gtk+-1.2*"

# Make sure to compile this
PATCHES="$FILESDIR/remove-configure.diff"
