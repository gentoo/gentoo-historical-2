# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xwud/xwud-1.0.2.ebuild,v 1.5 2009/12/27 17:57:21 josejx Exp $

inherit x-modular

DESCRIPTION="image displayer for X"

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"
