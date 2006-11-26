# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/font-bitstream-100dpi/font-bitstream-100dpi-1.0.0.ebuild,v 1.10 2006/11/26 23:32:12 flameeyes Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular


DESCRIPTION="X.Org Bitstream bitmap fonts"
RESTRICT="mirror"
KEYWORDS="amd64 arm ~hppa ia64 ~ppc ppc64 s390 sh ~sparc ~x86 ~x86-fbsd"
RDEPEND=""
DEPEND="${RDEPEND}
	x11-apps/bdftopcf"
