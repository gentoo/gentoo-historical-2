# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/font-bitstream-speedo/font-bitstream-speedo-1.0.0.ebuild,v 1.8 2007/07/15 05:13:09 mr_bones_ Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="Bitstream Speedo fonts"
KEYWORDS="~amd64 arm ~hppa ia64 ~ppc ppc64 s390 sh ~sparc ~x86 ~x86-fbsd"
RDEPEND=""
DEPEND="${RDEPEND}
	media-libs/fontconfig"
